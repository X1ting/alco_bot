class CreateDrinkCommand < ROM::Commands::Create
  class CreateDrinkCommandError < StandardError; end

  relation :drinks
  register_as :create

  result :one

  def execute(user_id:, drunk_at:, drink_id:, drink_type:, abv:, volume:)
    data = { drunk_at: drunk_at, drink_id: drink_id, drink_type: drink_type, abv: abv, volume: volume }.to_json
    result = relation.rpush(user_id, data).first
    if result
      data = relation.with(auto_struct: false).lrange(user_id, 0, -1).first
      [{ user_id: user_id, drunk_drinks: data.map{ |item| JSON.parse(item, symbolize_names: true) } }]
    else
      raise CreateDrinkCommandError
    end
  end
end
