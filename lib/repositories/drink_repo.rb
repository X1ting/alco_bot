module Repositories
  class DrinkRepo < ROM::Repository[:drinks]
    include ArgsImport['rom']

    def create(attributes)
      drinks.map_to(Entities::UserDrunk).command(:create).call(attributes)
    end

    def find_by_user_id(user_id)
      data = drinks.with(auto_struct: false).lrange(user_id, 0, -1)
      mapper = -> (data) do
        drunk_drinks = data.first.map{ |item| JSON.parse(item, symbolize_names: true) }
        [{ user_id: user_id, drunk_drinks: drunk_drinks }]
      end

      mapped = data >> mapper

      mapped.map_to(Entities::UserDrunk).one
    end

    def all
      user_ids = drinks.with(auto_struct: false).keys('*')

      mapper = -> (user_ids) do
        user_ids.first.map do |user_id|
          data = drinks.with(auto_struct: false).lrange(user_id, 0, -1).first
          drunk_drinks = data.map{ |item| JSON.parse(item, symbolize_names: true) }
          { user_id: user_id, drunk_drinks: drunk_drinks }
        end
      end

      mapped = user_ids >> mapper

      mapped.map_to(Entities::UserDrunk).to_a
    end
  end
end
