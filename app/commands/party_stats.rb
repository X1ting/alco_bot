module Commands
  class PartyStats < Base
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
      volume = drink_service.total_volume
      formatted_volume = if volume > 1000
        "#{volume.to_f / 1000}l."
      else
        "#{volume}ml."
      end
      <<~MARKDOWN
        Last day:
        **Volume:** #{formatted_volume}
        **Alcohol:** #{drink_service.total_alc.to_i}ml.
        **Glasses:** #{drink_service.total_last_day}
      MARKDOWN
    end
  end
end
