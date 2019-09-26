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
        #{drink_service.user_total_emoji(chat_id)}
        **Total volume:** #{formatted_volume}
        **Total alcohol:** #{drink_service.user_total_alc(chat_id).to_i}ml.
        **Total glasses:** #{drink_service.total}
      MARKDOWN
    end
  end
end
