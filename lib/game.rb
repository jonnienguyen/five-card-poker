class Card
  attr_reader :value, :suit
  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{@value} of #{@suit}"
  end
end

class Deck
  attr_accessor :complete_deck
  # Using standard French 56-cards deck (includes french)
  def initialize
    @complete_deck = createInitialDeck
  end

  def createInitialDeck
    suits = ["Spades", "Hearts", "Diamonds", "Club"]
    type_cards = ["Ace", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
    @complete_deck = type_cards.product(suits)
    @complete_deck.shuffle()
  end

  def dealCard
    # one_card = @complete_deck.sample(1 + rand(@complete_deck.count))
    # @complete_deck.delete(one_card)
    # one_card
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

  def initialize(hand = Hand.new, pot = 1000)
    # @name = name
    @hand = hand
    @pot = pot
    # @choice = gets
  end

  # def get_hand
  #   return @hand
  # end

  def discord
  end

  def action
  end
end

class Game

  attr_accessor :current_deck, :whose_turn, :bets, :players

  def initialize(player_names)
    @current_deck = Deck.new
    @players = create_players(player_names)
    @whose_turn = @players.first
    @pots = 0
    @bets = 0
  end

  def start_game
    initial_dealing
  end

  def next_turn
  end

  def initial_dealing
    @players.each do |player|
      5.times {player.hand.add_card(@current_deck.dealCard)}
    end


  end


  def create_players(player_names)
    players = []

    player_names.each {|p| players << Player.new}
    players
  end
end

fake_player = Game.new(["john", "bob", "mike"])
fake_player.start_game
puts fake_player.players[0].hand
