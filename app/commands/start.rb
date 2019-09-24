module Commands
  class Start < Base
    WELCOME_TEXT = """
      💎 Hi wild Rubyist! I'm RubyRussia 2019 AlcoBot 💎

      *What did you drink already?*
    """.freeze

    private

    def handle_call(message)
      send_message(
        chat_id: message.chat.id,
        text: WELCOME_TEXT,
        parse_mode: :markdown,
        reply_markup: Keyboards::MainReplyKeyboard.new.call
      )
    end
  end
end
