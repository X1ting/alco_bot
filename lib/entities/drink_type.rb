module Entities
  class DrinkType < ROM::Struct
    def friendly_name
      "#{drink.emoji} #{drink.name} #{drink.abv}%"
    end
  end
end
