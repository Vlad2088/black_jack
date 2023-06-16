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

  def charge
    @cash -= Game::BETTING
  end

  def get_a_win(index)
    @cash += index
  end


  def scoring
    total_points = 0

    @cards_game.each do |card|
      value = card.value

      points = CardDeck::CARD_VALUES[value]
      total_points += points
    end

    @cards_game.select { |card| card.suit.start_with?('A') }.count.times do
      total_points -= 10 if total_points > 21
    end

    total_points
  end
end
