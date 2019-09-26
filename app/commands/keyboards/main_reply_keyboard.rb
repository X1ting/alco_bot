module Commands
  module Keyboards
    class MainReplyKeyboard
      include KeyboardHelpers

      def call
        reply_keyboard(button('🍻 Drink-in!'), button('📊 Stats'))
      end
    end
  end
end
