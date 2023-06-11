class User

  attr_reader :name, :cards, :cards_game, :cash

  def initialize(name)
    @name = name
    @cash = 100
    @deck = CardDeck.new
    @cards_game = []
  end

   # Раздать карты игрокам
  def card_distribution
    cards = @deck.cards.sample(2)
    @cards_game = cards
    @deck.cards = @deck.cards - cards
  end

  # Добовление карт в игру
  def add_card
    cards = @deck.cards.sample(1)
    @cards_game.concat(cards)
    @deck.cards = @deck.cards - cards
  end

  def cash_in_bank
    @cash -= 10
  end

  def get_a_win(index)
    @cash += index
  end


  def scoring
    sum = 0
    ace_count = 0

    @cards_game.each do |card|
      value = card.value
      if value == 'A'
        ace_count += 1
        sum += 11
      elsif %w[J Q K].include?(value)
        sum += 10
      else
        sum += value.to_i
      end
    end

    while sum > 21 && ace_count > 0
      sum -= 10
      ace_count -= 1
    end

    sum
  end
end
