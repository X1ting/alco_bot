module Services
  class Drink
    include Import[
      repo: 'repositories.drink_repo',
      drink_types_repo: 'repositories.drink_type_repo',
    ]

    THROTTLING_DRINK_TIMEOUT = 60 # 5 minutes

    SCALE_OF_DRUNKNESS = {
      1 => ['🇷🇺 In Russia we say: mezdu pervoi i vtoroi pererivchik nebolshoi 🇷🇺', '💫 Good start! 💫'],
      2 => ['🏋️‍♂️ While you were finishing this beer - I was downd my third glass 🏋️‍♀️', '👮‍♂️ I hope you got here by bus? 👮‍♂️'],
      3 => ['🐳 Now it is time to pee 🐳', '🤓 Time to discuss the last GOT 🤓'],
      4 => ['4️⃣ The good, the bad and the fourth glass 4️⃣', '🎙 What do you think about karaoke bar? 🎙'],
      5 => ['🤞 How many fingers are there? ✌️', '💔 Time to call your ex 💔'],
      6 => ['❓ New quest: you should to find Anton Davydov and ask him smth about Hanami ❓'],
      7 => ['🍺 Remember your first glass? Neither do I 🍺', '💣 I think it is time to get hard stuff 💣'],
      8 => ['👋 Now I leave your alone with your beer, YOU WON! 👋']
    }

    def drink(user_id, username, drink, volume)
      repo.create(user_id: user_id, username: username, drunk_at: Time.now, drink_id: drink.id, drink_type: drink.name, abv: drink.abv, volume: volume)
    end

    def last(user_id)
      repo.find_by_user_id(user_id).drunk_drinks.sort_by(&:drunk_at).last
    end

    def all_drinks
      repo.all.map(&:drunk_drinks).flatten
    end

    def all_drinks_last_day
      all_drinks.select do |drink|
        drink.drunk_at >= (Time.now - 60 * 60 * 11)
      end
    end

    def user_by_last_day(user_id)
      repo.find_by_user_id(user_id).drunk_drinks.select do |drink|
        drink.drunk_at >= (Time.now - 60 * 60 * 11)
      end
    end

    def user_total(user_id)
      repo.find_by_user_id(user_id).drunk_drinks.count
    end

    def user_total_by_last_day(user_id)
      user_by_last_day(user_id).count
    end

    def user_total_emoji(user_id)
      user_by_last_day(user_id).reduce("") do |acc, drink|
        emoji = drink_types_repo.by_id(drink.drink_id).emoji
        acc << emoji
      end
    end

    def user_total_volume(user_id)
      user_by_last_day(user_id).reduce(0) do |acc, drink|
        acc += drink.volume
      end
    end

    def user_total_alc(user_id)
      user_by_last_day(user_id).reduce(0) do |acc, drink|
        drink_type = drink_types_repo.by_id(drink.drink_id)
        alc_volume = (drink_type.abv.to_f / 100) * drink.volume.to_f
        acc += alc_volume
      end
    end

    def total_last_day
      all_drinks_last_day.count
    end

    def total
      repo.all.map do |user_drunk|
        user_drunk.drunk_drinks.count
      end.reduce(:+)
    end

    def total_volume
      all_drinks_last_day.reduce(0) do |acc, drink|
        acc += drink.volume
      end
    end

    def total_alc
      all_drinks_last_day.reduce(0) do |acc, drink|
        drink_type = drink_types_repo.by_id(drink.drink_id)
        alc_volume = (drink_type.abv.to_f / 100) * drink.volume.to_f
        acc += alc_volume
      end
    end

    def user_stats_by_username(username)
      users_stats[username]
    end

    def users_stats
      all_drinks_last_day.reduce({}) do |acc, drink|
        acc[drink.username] = { alc_volume: 0.0, volume: 0, count: 0 } unless acc[drink.username]
        drink_type = drink_types_repo.by_id(drink.drink_id)
        alc_volume = (drink_type.abv.to_f / 100) * drink.volume.to_f

        acc[drink.username][:alc_volume] += alc_volume
        acc[drink.username][:volume] += drink.volume
        acc[drink.username][:count] += 1

        acc
      end
    end

    def leader_by_alc
      users_stats.sort_by { |k,v| v[:alc_volume] }.first(3)
    end

    def leader_by_volume
      users_stats.sort_by { |k,v| v[:volume] }.first(3)
    end

    def leader_by_count
      users_stats.sort_by { |k,v| v[:count] }.first(3)
    end

    def drinks_fast?(user_id)
      last = last(user_id)
      last && (last(user_id).drunk_at + THROTTLING_DRINK_TIMEOUT) > Time.now
    end

    def time_to_drink(user_id)
      last(user_id).drunk_at + THROTTLING_DRINK_TIMEOUT
    end

    def scale_of_drunkness(user_id)
      scale = SCALE_OF_DRUNKNESS[user_total_by_last_day(user_id)]
      return '🥴 Sorry fellow, I am too drunk. Count it yourself 🥴' if scale.nil?
      scale.sample
    end
  end
end
