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
  attr_accessor :hand, :pot

  def initialize(hand = [], pot = 1000)
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
    @players = create_players(player_names)
    @whose_turn = @players.first
    @pots = 0
    @bets = {}
    # To keep track of players that folded
    @folded_players = []
  end

  def start_game
    initial_dealing
    # betting_round
    # discard_round
    # betting_round
    # showdown
  end

  def next_turn
    current_player = @players.index(@whose_turn)
    @whose_turn = @players[(current_player + 1) % players.length]
  end

  def initial_dealing
    @players.each do |player|
      5.times {player.hand << @current_deck.dealCard}

    end
  end

  def betting_round

    loop do
      choice = player.action
      case choice
      when :fold
        puts "Player #{player.name} folded."
        @folded_players << Player[player].pop
        break
      when :see
        puts "The current bets made are:"
        @bets.each do |name, bet|
          puts "#{name} made betted $#{bet}"
        end

        break
      when :raise
        break
      end
    end
    next_turn
  end

  def create_players(player_names)
    players = []
    player_names.each do |name|
      name = Player.new()
      players << name
    end
    return players
  end
end
