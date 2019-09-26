module Commands
  class Leaderships < Base
    include Import[drink_service: 'services.drink']

    private

    def handle_call(message)
      chat_id = message.chat.id
      send_message(
        chat_id: chat_id,
        text: format_message,
        parse_mode: :markdown
      )
    end

    def format_message
      <<~MARKDOWN
        **Leaderships:**
        By volume:
        #{format_users(drink_service.leader_by_volume, :volume).join("ml. \n")}
        By abv:
        #{format_users(drink_service.leader_by_alc, :alc_volume).join("ml. \n")}
        By count:
        #{format_users(drink_service.leader_by_count, :count).join(" glasses \n")}
      MARKDOWN
    end

    def format_users(leaders, key)
      rewards = {1 => "🥇", 2 => "🥈", 3 => "🥉"}
      leaders.map.with_index do |leader, index|
        "#{rewards[index + 1]} #{leader.first} - #{leader.last[key]}"
      end
    end
  end
end
