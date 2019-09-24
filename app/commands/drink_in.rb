module Commands
  class DrinkIn < Base
    include Import[repo: 'repositories.drink_type_repo']

    def handle_call(message)
      username = username_for(message.from)

      send_message(
        chat_id: message.chat.id,
        text: 'Good boy!',
        parse_mode: :markdown,
        reply_markup: menu_keyboard
      )
    end

    def menu_keyboard
      buttons = repo.all.map { |drink| button_for(drink) }
      reply_keyboard(buttons)
    end

    def button_for(drink)
      button("#{drink.emoji} #{drink.name} #{drink.abv}%")
    end
  end
end
