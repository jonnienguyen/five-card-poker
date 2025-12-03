class Game
  attr_accessor :deck, :players, :current_turn_player
  attr_reader :folded_players, :bets, :pot

  def initialize(player_names)
    @deck = Deck.new
    @players = create_players_and_deal(player_names)
    @current_turn_player = @players.first
    @bets = {}
    @folded_players = []
    @pot = 0
  end

  def play
    betting_round
    discard_round
    betting_round
    showdown
  end

  private

  def create_players_and_deal(player_names)
    players = player_names.map { |name| Player.new(name) }
    deal_initial_hands(players)
    players
  end

  def deal_initial_hands(players)
    players.each do |player|
      5.times { player.hand << @deck.deal_card }
    end
  end

  def betting_round
    @players.each do |player|
      @current_turn_player = player
      player.display_hand

      action = player.get_action

      case action
      when :fold
        handle_fold(player)
      when :see
        handle_see(player)
      when :raise
        handle_raise(player)
      end

      update_pot
    end

    remove_folded_players
  end

  def handle_fold(player)
    puts "\nPlayer #{player.name} folded."
    @folded_players << player
  end

  def handle_see(player)
    display_current_bets
    bet_amount = get_valid_bet_amount(player)
    place_bet(player, bet_amount)
  end

  def handle_raise(player)
    highest_bet = @bets.values.max || 0
    puts "\nThe current highest bet is: $#{highest_bet}"

    if player.pot < highest_bet
      puts "You cannot raise. Going all-in with $#{player.pot}"
      place_bet(player, player.pot)
    else
      bet_amount = get_raise_amount(player, highest_bet)
      place_bet(player, bet_amount)
    end
  end

  def get_valid_bet_amount(player)
    loop do
      puts "How much would you like to bet? (Max: $#{player.pot})"
      bet = gets.chomp.to_f

      return bet if bet <= player.pot && bet > 0
      puts "Invalid amount. Must be between $0 and $#{player.pot}"
    end
  end

  def get_raise_amount(player, minimum)
    loop do
      puts "Enter raise amount (must be greater than $#{minimum}):"
      bet = gets.chomp.to_f

      return bet if bet > minimum && bet <= player.pot
      puts "Invalid raise. Must be more than $#{minimum} and at most $#{player.pot}"
    end
  end

  def place_bet(player, amount)
    player.pot -= amount
    @bets[player.name] = amount
  end

  def display_current_bets
    return if @bets.empty?

    puts "\nCurrent bets:"
    @bets.each { |name, amount| puts "  #{name}: $#{amount}" }
  end

  def update_pot
    @pot = @bets.values.sum
  end

  def remove_folded_players
    @players -= @folded_players
  end

  def discard_round
    @players.each do |player|
      @current_turn_player = player
      player.display_hand

      discard_indices = get_discard_indices(player)
      replace_cards(player, discard_indices)
    end
  end

  def get_discard_indices(player)
    count = player.get_discard_count
    return [] if count.zero?

    indices = []
    count.times do |i|
      loop do
        puts "(Discard #{i + 1}/#{count}) Enter card number to discard (1-5):"
        index = gets.chomp.to_i

        if (1..5).include?(index) && !indices.include?(index)
          indices << index
          break
        else
          puts "Invalid input or already selected."
        end
      end
    end
    indices
  end

  def replace_cards(player, discard_indices)
    discard_indices.each do |index|
      player.hand[index - 1] = @deck.deal_card
    end
    puts "\n(To #{player.name}) Your updated hand:"
    player.display_hand
  end

  def showdown
    puts "\n========== SHOWDOWN =========="

    hand_evaluator = Hand.new(@players)
    hand_evaluator.evaluate_all_hands
    winners = hand_evaluator.winners

    display_hand_rankings(hand_evaluator)
    distribute_pot(winners)
  end

  def display_hand_rankings(hand_evaluator)
    puts "\nHand Rankings:"
    hand_evaluator.results.each do |name, result|
      hand_type = result[1]
      puts "  #{name}: #{hand_type}"
    end
  end

  def distribute_pot(winners)
    share_per_winner = @pot / winners.length

    puts "\nWinners:"
    winners.each do |name, result|
      hand_type = result[1]
      puts "  #{name} wins with #{hand_type}!"
    end

    @players.each do |player|
      if winners.key?(player.name)
        player.pot += share_per_winner
      end
    end

    display_final_pots
  end

  def display_final_pots
    puts "\nFinal Pots:"
    @players.each do |player|
      puts "  #{player.name}: $#{player.pot}"
    end
  end
end
