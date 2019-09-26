module Commands
  class DrinkIn < Base
    include Import[
      repo: 'repositories.drink_type_repo',
      drink_service: 'services.drink'
    ]

    def handle_callback(callback, args)
      id = args.fetch('id') { raise(FallbackError) }
      drink = repo.by_id(id) || raise(FallbackError)
      volume = args.fetch('volume', false)
      count = args.fetch('count', false)
      if !count && !volume
        ask_for_volume(callback, drink)
      elsif !count && volume
        ask_for_count(callback, drink, volume)
      else
        username = username_for(callback.from)
        count.times { drink_service.drink(callback.message.chat.id, username, drink, volume) }
        report_success(callback)
      end
    end

    def ask_for_volume(callback, drink)
      volume_buttons = drink.volumes.map { |volume| button(volume, 'volume', { id: drink.id, volume: volume }) }
      edit_message_text(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
        text: "Let choose volume of drink",
        parse_mode: :markdown,
        reply_markup: inline_keyboard(
          volume_buttons,
          [button('Cancel', 'back', replace: true) ]
        )
      )
    end

    def ask_for_count(callback, drink, volume)
      count_buttons = [1,2,3,4].map { |count| button(count, 'count', { id: drink.id, volume: volume, count: count }) }
      edit_message_text(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id,
        text: "Let choose count of glasses",
        parse_mode: :markdown,
        reply_markup: inline_keyboard(
          count_buttons,
          [button('Cancel', 'back', replace: true) ]
        )
      )
    end

    def report_success(callback)
      delete_message(
        message_id: callback.message.message_id,
        chat_id: callback.message.chat.id
      )

      send_message(
        chat_id: callback.message.chat.id,
        text: "Well done!",
        parse_mode: :markdown,
        reply_markup: Keyboards::MainReplyKeyboard.new.call
      )
    end
  end
end
