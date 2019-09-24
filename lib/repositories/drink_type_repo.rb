module Repositories
  class DrinkTypeRepo < ROM::Repository[:drink_types]
    include ArgsImport['rom']

    def by_id(id)
      drink_types.restrict(id: id).first
    end

    def all
      drink_types.to_a
    end
  end
end
