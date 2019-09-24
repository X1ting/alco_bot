class DrinkTypes < ROM::Relation[:yaml]
  gateway :default

  schema(infer: true) do
    attribute :id, ROM::Types::Integer
    attribute :name, ROM::Types::String
    attribute :abv, ROM::Types::Integer
    attribute :emoji, ROM::Types::String
    attribute :volumes, ROM::Types::Array
  end

  auto_struct true

  def by_pk(id)
    restrict(id: id)
  end
end
