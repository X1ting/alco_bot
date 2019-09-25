class Dispatcher
  def initialize(bot)
    @fallback = Commands::Unknown.new(bot.api)
    @commands = {
      '/start' => Commands::Start.new(bot.api),
      '🍻 Drink-in!' => Commands::ChooseDrinkType.new(bot.api),
      '◀️ Back' => Commands::Back.new(bot.api),
    }

    @callbacks = {
      'back' => commands['◀️ Back'],
      'drink' => commands['🍻 Drink-in!'],
      'volume' => commands['🍻 Drink-in!'],
      'count' => commands['🍻 Drink-in!'],
    }
  end

  def call(message)
    case message
    when Telegram::Bot::Types::Message
      dispatch_message(message)
    when Telegram::Bot::Types::CallbackQuery
      dispatch_callback(message)
    end
  end

  private

  attr_reader :commands, :callbacks, :fallback

  def dispatch_message(message)
    command_name = message.text&.sub(/_\d+$/, '')
    handler = commands.fetch(command_name, fallback)

    handler.call(message)
  rescue Commands::FallbackError
    fallback.call(message)
  end

  def dispatch_callback(callback)
    callback_name = JSON.parse(callback.data)['command']
    handler = callbacks.fetch(callback_name, fallback)

    handler.call(callback)
  rescue JSON::ParserError, Commands::FallbackError
    fallback.call(callback)
  end
end
