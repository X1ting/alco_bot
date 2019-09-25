module Entities
  class UserDrunk < ROM::Struct
    attribute :user_id, ROM::Types::Coercible::String
    attribute :drunk_drinks, ROM::Types::Strict::Array.of(DrunkDrink)
  end
end
