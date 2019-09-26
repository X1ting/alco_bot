class CreateDrinkCommand < ROM::Commands::Create
  class CreateDrinkCommandError < StandardError; end

  relation :drinks
  register_as :create

  result :one

  def execute(user_id:, username:, drunk_at:, drink_id:, drink_type:, abv:, volume:)
    data = { username: username, drunk_at: drunk_at, drink_id: drink_id, drink_type: drink_type, abv: abv, volume: volume }.to_json
    result = relation.rpush(user_id, data).first
    if result
      data = relation.with(auto_struct: false).lrange(user_id, 0, -1).first
      drunk_drinks = data.map{ |item| JSON.parse(item, symbolize_names: true) }
      [{ user_id: user_id, drunk_drinks: drunk_drinks }]
    else
      raise CreateDrinkCommandError
    end
  end
end
