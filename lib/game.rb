class Game

  attr_accessor :current_deck, :whose_turn, :bets, :players, :folded_players, :total_pots

  def initialize(player_names)
    @current_deck = Deck.new
    # Create a Player instance for each
    @players = create_and_deal(player_names)
    # Turn is determined by the index :)
    @whose_turn = @players.first.name
    @total_pots = 0
    @bets = {}
    # To keep track of players that folded
    @folded_players = []
  end

  def create_and_deal(player_names)
    # Create Player with an intital 5 cards
    players = []
    player_names.each do |name|
      name = Player.new(name)
      # Draw 5 cards each
      5.times {name.hand << @current_deck.dealCard}
      players << name
    end
    return players
  end

  def start_game
    # To simulate the flow of the game
    betting_round
    discard_round
    betting_round
    showdown
  end


  def betting_round
    @players.each do |player|
      @whose_turn = player.name
      player.display_hand
      # Get choice from Player class; three cases
      choice = player.action

      case choice

      when :fold
        puts "Player #{player.name} folded."
        @folded_players << player
      when :see
        betting_see(player)
      when :raise
        betting_raise(player)
      end
      # After add all bets to total pot
      @total_pots = @bets.values.sum
    end

  # After betting round, remove folded players
  @players -= @folded_players
  # puts get_names("current")
  end

  def discard_round
    @players.each do |player|
      @whose_turn = player
      # Holds the index at which player wants to discard
      discard_holder = []
      # Get times to discard [0,3]
      times_discard = player.discard
      # List the cards player has, in a nice formatted way
      player.display_hand

      # Get discard inputs
      puts "(To #{whose_turn.name}) Using the number on the left hand side, what card do you wish to discard?"
      times_discard.times do |i|
        puts "(##{i+1}) What card do you wish to discard:"
        discard_input = gets.chomp.to_i
        # Check if index card is already choose and number is in valid range
        until !(discard_holder.include?(discard_input)) && (1..5).include?(discard_input)
          puts "Sorry, thats an invalid number; you have already choose #{discard_holder}."
          discard_input = gets.chomp.to_i
        end
        discard_holder << discard_input
      end
      # After call helper to deal new card to player
      get_new_cards(player, discard_holder)
    end
  end

  def showdown
    puts "Time for the showdown!\n"

    result_hand = Hand.new(@players)
    # Gets each player hand strength
    result_hand.determine_players_strength
    # Get a list of winner(s)
    win_result = result_hand.winners

    # Iterate to show each player's strength
    result_hand.players_result.each do |player|
      puts "To #{player[0]}, your hand strength is #{player[1][1]}"
    end


    puts "\nThe winner(s) of the Game is"
    # In case there are multiple winners
    share_pot = @total_pots / win_result.length

    win_result.each do |winner_name, w_result|
      puts "#{winner_name} with #{w_result[1]}"

      # @players[winner_name].pot += share_pot.to_f
    end

    puts "\nHere are your pots after the game"
    @players.each do |player|
      # condition if it's the winner; if so then add the pot to them
      if win_result.keys.include?(player.name)
        player.pot += share_pot
      end
      puts "#{player.name} has #{player.pot} left."
    end
  end
  # Helper To get all names of player
  # Option to make it easier to display current players and the folded players
  def get_names(option)
    names = []
    if option == "current"
      @players.each do |p|
        names << p.name
      end
      return names
    elsif option == "folded"
        @folded_players.each do |f|
          names << f.name
        end
    end
    return names
  end

  private

  # helper for betting_round
  def betting_see(p)
    puts "The current bets made are:"
    @bets.each do |name, bet|
      puts "#{name} made betted $#{bet}"
    end

    puts "What amount are you betting?"
    get_bet = gets.chomp.to_f

    # To validate that betting amount is an allowed amount
    until (get_bet <= p.pot)
      puts "#{get_bet} #{p.pot}"
      puts "Sorry, your bet amount cannot exceed #{p.pot}"
      get_bet = gets.chomp.to_f
    end
    # Assign bet amount to player
    p.pot -= get_bet
    @bets[p.name] = get_bet
  end

  # helper for betting_round
  def betting_raise(p)
    # Incase of bets being empty
    highest_bet = @bets.values.max || 0
    puts "The current highest bet made is #{highest_bet}"

    # User will all-in if they cannot raise
    if p.pot < highest_bet
      puts "Sorry, you cannot raise the bet. Betting all your pot :( "
      @bets[p.name] = p.pot
      p.pot = 0
    else
      # To validate the raise amount is higher
      loop do
        raise_bet = gets.chomp.to_f
        if raise_bet > highest_bet
          p.pot -= raise_bet
          @bets[p.name] = raise_bet
          break
        else
          puts "Sorry, you must make a bet higher than #{highest_bet}"
        end
      end
    end
  end

  # helper for discard_round
  def get_new_cards(p, discarded)
    # discard card; given player and index of card (off by 1)
    discarded.each do |d|
      p.hand[d-1] = current_deck.dealCard
    end
    # Show the update hand for player
    puts "(To #{p.name}): #{p.hand}"

  end
end
