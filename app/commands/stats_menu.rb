module Commands
  class StatsMenu < Base
    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: "Which stats do you want to check",
        parse_mode: :markdown,
        reply_markup: Keyboards::StatsKeyboard.new.call
      )
    end
  end
end
