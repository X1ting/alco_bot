module Commands
  module Keyboards
    class StatsKeyboard
      include KeyboardHelpers

      def call
        reply_keyboard(button('👨‍🎤 Personal'), button('👨‍👩‍👧‍👦🎉 Party'), button('◀️ Back'))
      end
    end
  end
end
