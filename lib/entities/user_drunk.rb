module Entities
  class DrunkDrink < ROM::Struct
    CoercibleTime = ROM::Types::String.constructor do |value|
      ::Time.parse(value)
    rescue ArgumentError
      nil
    end

    attribute :drunk_at, CoercibleTime
    attribute :drink_id, ROM::Types::Coercible::Integer
    attribute :drink_type, ROM::Types::Coercible::String
    attribute :username, ROM::Types::Coercible::String
    attribute :abv, ROM::Types::Coercible::String
    attribute :volume, ROM::Types::Coercible::Integer
  end
  class UserDrunk < ROM::Struct
    attribute :user_id, ROM::Types::Coercible::String
    attribute :drunk_drinks, ROM::Types::Strict::Array.of(DrunkDrink)
  end
end
