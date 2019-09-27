module Commands
  class PersonalStats < Base
    include Import[drink_service: 'services.drink']

    private

    def handle_call(message)
      chat_id = message.chat.id
      send_message(
        chat_id: chat_id,
        text: message(chat_id),
        parse_mode: :markdown
      )
    end

    def message(chat_id)
      volume = drink_service.user_total_volume(chat_id)
      formatted_volume = if volume > 1000
        "#{volume.to_f / 1000}l."
      else
        "#{volume}ml."
      end
      <<~MARKDOWN
        Last day:
        #{drink_service.user_total_emoji(chat_id)}
        **Volume:** #{formatted_volume}
        **Alcohol:** #{drink_service.user_total_alc(chat_id).to_i}ml.
        **Glasses:** #{drink_service.user_total_by_last_day(chat_id)}
      MARKDOWN
    end
  end
end
