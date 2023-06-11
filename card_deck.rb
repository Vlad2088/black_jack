require_relative 'card'

class CardDeck
  SUITS = ['+', '<3', '^', '<>']
  CARD_VALUES = {'A' => 11, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7,
                '8' => 8, '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10
                }.freeze


  attr_accessor :cards

  def initialize
    @cards = []
    create_deck
  end

  private

  def create_deck
    SUITS.each do |suit|
      CARD_VALUES.each do |value, _|
        @cards << Card.new(suit, value)
      end
    end
  end
end