class Card
  # NEEDED ?
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
    suits = ["Diamonds", "Club", "Hearts", "Spades"]
    type_cards = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]
    # To get the 56 combinations
    @complete_deck = type_cards.product(suits)
    # After shuffle the deck
    @complete_deck.shuffle()
  end

  def dealCard
    @complete_deck.pop
  end

end

class Hand
  # attr_reader :cards
  # DELETE  ????
  def initialize
    @player_hand = []
  end
  def add_card(card)
    @player_hand << Card.new(card[0], card[1])
  end
  def to_s
    hand_str = @player_hand.map(&:to_s).join(", ")
  end

  # Royal flush - 5 cards of same suits; rank 10 to ace.

  # Straight flush - 5 cards of same suits; successtive rank.

  # Four of a Kind - 4 cards of differnt suits, same rank;

  # Full house - 3 cards of same rank (each in different suit) and 2 cards of same rank (different suit)

  # Flush - 5 cards of the same suit, rank doesnt matter (tie based on rank)

  # Straight - 5 cards in sequence, more than 1 suit

  # Three of a kind - 3 cards of the same rank in different rank

  # Two pair - 2 sets of cards with the same rank

  # Pair - 2 differtent set of cards with same rank in differnt suits

  # High card - None of the above combinations; determined by the highest ranking card in hand

end

class Player
  attr_accessor :name, :hand, :pot

  def initialize(name, hand = [], pot = 1000)
    @name = name
    @hand = hand
    @pot = pot
  end

  def discard
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
      puts menu
      choice = gets().chomp.downcase
      case choice
      when "fold"
        return :fold
      when "see"
        return :see
      when "raise"
        return :raise
      else
        puts "Invalid choice!"
      end
    end
  end
end

class Game

  attr_accessor :current_deck, :whose_turn, :bets, :players

  def initialize(player_names)
    @current_deck = Deck.new
    # Create a Player instance for each
    @players = create_and_deal(player_names)
    # Turn is determined by the index :)
    @whose_turn = @players.first
    @pots = 0
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

  def next_turn
    current_player = @players.index(@whose_turn)
    @whose_turn = @players[(current_player + 1) % players.length]
  end

  def start_game
    # betting_round
    # discard_round
    # betting_round
    # showdown
  end


  def betting_round
    @players.each do |player|
      choice = player.action

      case choice

      when :fold
        puts "Player #{player.name} folded."
        @folded_players << @players.delete(player)
        break

      when :see
        betting_see(player)
        break

      when :raise
        betting_raise(player)
        break
      end

      next_turn
    end
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
      puts "Sorry, your bet amount cannot exceed #{p.pot}"
      get_bet = gets.chomp.to_f
    end
    # Assign bet amount to player
    @bets[p.name] = get_bet
  end

  # helper for betting_round
  def betting_raise(p)
    # Incase of bets being empty
    highest_bet = bets.value.max || 0
    puts "The current highest bet made is #{highest_bet}"

    # User will all-in if they cannot raise
    if p.pot < highest_bet
      puts "Sorry, you cannot raise the bet. Betting all your pot :( "
      @bets[p.name] = p.pot
      p.pot = 0
    else
      raise_bet = gets.chomp.to_f
      # To validate the raise amount is higher
      until raise_bet > highest_bet
        puts "Sorry, you must make a bet higher than #{highest_bet}"
        raise_bet = gets.chomp.to_f
      end
      @bets[p.name] = raise_bet
    end
  end
end
