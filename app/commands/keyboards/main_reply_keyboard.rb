module Commands
  module Keyboards
    class MainReplyKeyboard
      include KeyboardHelpers

      def call
        reply_keyboard(button('🍻 Drink-in!'), button('🍻 Drunk beer!'))
      end
    end
  end
end
