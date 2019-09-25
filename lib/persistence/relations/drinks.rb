class Drinks < ROM::Relation[:redis]
  gateway :redis
  schema {}
end
