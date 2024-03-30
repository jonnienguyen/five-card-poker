class Card

  attr_reader :value, :suit
  # Pass in a unformatted card (array)
  def initialize(card)
    @value = card[0]
    @suit = card[1]
  end
  # For easier output; format card
  def to_s
    "#{@value} of #{@suit}"
  end
end

class Deck
  attr_accessor :complete_deck
  # Using standard French 56-cards deck (includes Ace)
  def initialize
    # Create the initial deck
    @complete_deck = createInitialDeck
  end

  def createInitialDeck
    # Create the deck of all different combination
    suits = ["Diamonds", "Clubs", "Hearts", "Spades"]
    type_cards = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]
    # To get the 56 combinations
    @complete_deck = type_cards.product(suits)
    # After shuffle the deck
    @complete_deck.shuffle()
  end

  def dealCard
    # Since it already shuffle; it gets the last card but same idea :/
    @complete_deck.pop
  end

end

class Hand
  attr_accessor :all_players_hand, :players_result
  def initialize(all_players_hand=[])
    # Pass in all players from Game
    @all_players_hand = all_players_hand
    # Used to store each player's strength
    @players_result = {}
  end

  def determine_players_strength
    # Iterate and gets each player's strength then store it
    @all_players_hand.each do |p|
      result = hand_strength(p.hand)
      # result is a array: (0) int to determine winner at end; (1) name of hand strength
      @players_result[p.name] = result
    end

  end

  def hand_strength(p_hand)
    sorted_hand = sort_hand(p_hand) # Sort the player's hand by values (and replace with an integer)
    values_order = sorted_hand.map {|value| value[0]} # 1d sorted array of values (should be all integers)
    # map into 2d hash for occurence; then flatten into 1d hash
    values_count = values_order.uniq.map { |x| {x=>values_order.count(x)} }.reduce({}, :merge)
    suits_count = get_suits(sorted_hand) # Get hash of occurence of each suits
    # puts values_order
    # puts values_count
    # puts suits_count

    # Royal flush - 5 cards of same suits AND rank 10 to ace.
    if suits_count.values.max == 5 && (values_order == [10, 11, 12, 13, 14])
      return [10, "Royal Flush"]
    # Straight flush - 5 cards of same suits; successive rank. should be 4 since max - min = 4
    elsif suits_count.values.max == 5 && (values_order.max - values_order.min == 4) && values_order.uniq.length == 5
      return [9, "Straight Flush"]
    # Four of a Kind - any 4 matching values
    elsif values_count.values.max == 4
      return [8, "Four of a Kind"]
    # Full house - 3 cards of same values; 2 cards of different values
    elsif values_count.values.sort == [2, 3]
      return [7, "Full House"]
    # Flush - 5 cards of the same suit, values doesnt matter (tie based on rank)
    elsif suits_count.values.max == 5
      return [6, "Flush"]
    # Straight - 5 cards in sequence, more than 1 suit
    elsif values_order.max - values_order.min == 4 && values_order.uniq.length == 5
      return [5, "Straight"]
    # Three of a kind - 3 cards of the same rank in different rank
    elsif values_count.values.max == 3
      return [4, "Three of a Kind"]
    # Two pair - 2 sets of cards with the same values
    elsif values_count.values.count(2) == 2 && values_count.keys.length == 3
      return [3, "Two Pair"]
    # One Pair - 2 same values
    elsif values_count.values.count(2) == 1
      return [2, "One Pair"]
    # High card - None of the above combinations; determined by the highest ranking card in hand
    else
      return [1, "High Card"]
    end
  end

  def winners
    # Since determine_players_strength sorted by highest already
    highest_rank = @players_result.values[0][0]
    # Gets a list of of winner(s)
    the_winners = @players_result.filter {|k, v| v[0] == highest_rank}
    return the_winners
  end

  private

  # Helper to sort hand AND values to integer
  def sort_hand(h)
    custom_sort_order = {
    "Jack" => 11,
    "Queen" => 12,
    "King" => 13,
    "Ace" => 14
  }
    # sorted_h = h.sort_by { |value, suit| custom_sort_order[value] || value.to_i }
    sorted_h = h.map do |value, suit|
      [custom_sort_order[value] || value.to_i, suit]
    end
    return sorted_h.sort
  end
  # Helper to get suits occurence
  def get_suits(h)
    suit_counts = Hash.new(0)
    h.each do |card|
      value, suit = card
      suit_counts[suit] += 1
    end
    return suit_counts
  end
end

class Player
  attr_accessor :name, :hand, :pot

  def initialize(name, hand = [], pot = 1000)
    @name = name
    @hand = hand
    @pot = pot # Set default
  end

  def discard
    # prompt player for card they wish to dicard
    puts "(To #{@name}) How many card do you wish to discard (between 0 and 3)?"
    num_cards = gets.chomp.to_i
    # Check if its between 0 and 3
    until (0..3).include?(num_cards)
      puts "Sorry, enter an valid number of cards to discard:"
      num_cards = gets.chomp.to_i
    end
    # Return an integer [0,3]
    return num_cards
  end

  def action
    menu =
    "
    Three Options:
    1. Fold: Discard hand, foreit the current pot
    2. See current bet (Call): See currnet bets, and match current highest bet
    3. Raise: Increase current highest bet
    "
    while true
      # Continues to prompt user for input if invalid;
      # else returns therefore ending loop
      # puts menu
      choice = gets.downcase.chomp

      case choice
      when "fold"
        return :fold
        break
      when "see"
        return :see
        break
      when "raise"
        return :raise
        break
      else
        puts "Invalid choice!"
      end
    end
  end

  def display_hand
    puts "\n(To #{@name}) here are your cards:"
    5.times do |i|
      c = Card.new(hand[i])
      puts "#{i+1} - #{c}"
    end
  end
end

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
