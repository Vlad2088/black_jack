require_relative 'card_deck'
require_relative 'user'
require_relative 'dealer'
require_relative 'player'
require_relative 'validation_error'

class Game
  BETTING = 10

  #Добавить колоду
  def initialize
    @dealer = Dealer.new('Dealer')
    @bank = 0
  end

  def run
    loop do
      puts [
        'Вы готовы сыграть в BLACK JACK?',
        '1 - Готов',
        '0 - Выход'
      ]
    
      mode = gets.to_i
      case mode
      when 1
        creating_player
        control
      when 0
        break
      end
    end
  end

  private

  attr_reader :cards, :cards_game, :player, :dealer
  attr_accessor :bank

  def control
    puts "Добро пожаловать в игру #{player.name}"
    loop do
      puts [
        'Выберете:',
        '1 - Проверить остаток Ваших денежных средств',
        '2 - Начать игру',
        '0 - Выход'
      ]

      input = gets.to_i
      case input
        when 1
          puts "На Вашем счету: #{player.cash} монет."
        when 2
          self.bank = load_bank
          sleep(2)
          player_points = run_player_game
          dealer_points = run_dealer_game
          self.bank = check_points(bank, player_points, dealer_points)
        when 0
          break
      end
    end
  end

  def creating_player
    puts "Введите имя"
    name = gets.chomp.capitalize

    @player = Player.new(name)
  rescue ValidationError => e
    puts e.message
    retry
  end

  #Положить деньги в банк
  def load_bank
    player.charge
    dealer.charge

    bank = BETTING * 2
    puts "Банк пополнен! В банке #{bank} монет." 
    bank
  end
  
  #игра дилера
  def run_dealer_game
    dealer.card_distribution
    dealer_points = dealer.scoring
    puts 'У Дилера 2 карты **.'
    sleep(2)

    if dealer_points <= 17
      dealer.add_card
      dealer_points = dealer.scoring
      puts 'Дилер взял еще 1 карту. У дилера 3 карты ***.'
    else
      puts 'Дилер готов открыть карты'
    end

    dealer_points
  end

  #игра пользователя
  def run_player_game
    player.card_distribution
    player_points = player.scoring
    puts "Ваши карты: #{player.cards_game.join(', ')}. Сумма Ваших очков: #{player_points}"

    puts [
      'Добавить еще 1 карту?',
      "Введите '1', чтобы добавить."
    ]
    
    num = gets.to_i

    if num == 1 
      player.add_card
      player_points = player.scoring
      puts "Ваши карты: #{player.cards_game.join(', ')}. Сумма Ваших очков: #{player_points}"
    else
      puts 'Вы отказались от дополнительной карты!'
    end
    player_points
  end

  def check_points(bank, player_points, dealer_points)
    puts 'Внимание идет подсчет очков!'
    sleep(5)

    if dealer_points > 21 && player_points > 21
      player.get_a_win(10)
      dealer.get_a_win(10)

      puts 'Все проиграли! Монеты возвращаются!'
      
    elsif dealer_points > 21 || player_points == 21 || player_points > dealer_points && player_points < 21
      player.get_a_win(bank)

      puts ["Победил #{player.name}!",
        "Количество очков Дилера: #{dealer_points}",
        "Количество Ваших очков: #{player_points}"
      ]

    elsif player_points > 21 || dealer_points > player_points
      dealer.get_a_win(bank)

      puts [
        "Победил Дилер!",
        "Количество очков Дилера: #{dealer_points}",
        "Количество Ваших очков: #{player_points}"
      ]
    else dealer_points == player_points
      player.get_a_win(10)
      dealer.get_a_win(10)

      puts 'У вас ничья! Монеты делятся поровну!'
    end

    bank -= 20
    bank
  end

end

Game.new.run