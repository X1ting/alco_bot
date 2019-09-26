module Commands
  class ChooseDrinkType < Base
    include Import[
      repo: 'repositories.drink_type_repo',
      drink_service: 'services.drink'
    ]

    WRONG_TIME_MESSAGES = [
      "⌛ They've paid me only for the evening hours ⌛",
      "⌛ Hey, the party has not yet started! ⌛"
    ]

    def handle_call(message)
      chat_id = message.chat.id
      drink_allowed = false

      if wrong_time?
        message = wrong_time_message
      elsif drinks_too_fast?(chat_id)
        message = too_fast_message(chat_id)
      else
        drink_allowed = true
        message = '📆 Choose a type of drink'
      end

      payload = {
        chat_id: chat_id,
        text: message,
        parse_mode: :markdown,
      }
      payload[:reply_markup] = menu_keyboard if drink_allowed
      send_message(**payload)
    end

    def wrong_time?
      # (7..17).cover?(Time.now.getlocal('+03:00').hour)
      false
    end

    def drinks_too_fast?(chat_id)
      drink_service.drinks_fast?(chat_id)
    end

    def wrong_time_message
      <<~MARKDOWN
        #{WRONG_TIME_MESSAGES.sample}
        _(This command works from 18:00 till 7:00)_
      MARKDOWN
    end

    def too_fast_message(chat_id)
      <<~MARKDOWN
        ⏳ I don't believe you are drinking that fast ⌛
        (we have a 60 seconds timeout between glasses, try again after #{next_drink_adviced_time(chat_id)})
        _Already drunk today: #{drunkness_scale(chat_id)}_
      MARKDOWN
    end

    def drunkness_scale(chat_id)
      drink_service.user_total_emoji(chat_id)
    end

    def next_drink_adviced_time(chat_id)
      drink_service.time_to_drink(chat_id).localtime('+03:00').strftime('%T')
    end

    def menu_keyboard
      buttons = repo.all.map { |drink| button_for(drink) }.each_slice(3).to_a
      inline_keyboard(*buttons)
    end

    def button_for(drink)
      button("#{drink.emoji} #{drink.name} #{drink.abv}°", 'drink', { id: drink.id })
    end
  end
end
