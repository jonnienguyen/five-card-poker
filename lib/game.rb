class Game

  attr_accessor :current_deck, :whose_turn, :bets, :num_players

  def initialize(players_name)
    @current_deck = Deck.new
    @pots = 0
    @bets = {}
    @players = create_players(players_name)
    @whose_turn = @players.first
  end

  def start_game
  end

  def next_turn
  end



  def create_players()
    players_name.each do |player_info|
    new_hand = []

    5.times do
      new_hand << @current_deck.dealCard
    end

    p = Player.new(player_info[0], new_hand, player_info[1])
    num_players << p
    end
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
    one_card = @complete_deck.sample(1 + rand(@complete_deck.count))
    @complete_deck.delete(one_card)
    return @complete_deck.pop
  end

end

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

class Hand
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

  def initialize(name, hand, pot = 1000)
    @name = name
    @hand = hand
    @pot = pot
    # @choice = gets
  end

  def get_hand
    return @hand
  end

  def discord
  end

  def action
  end
  # def option()
  #   # Enter the number of the card
  #   if @choice.strip == "discard"
  #     puts @hand
  #     which_cards.split = gets
  #     if which_cards.length > 3
  #       puts "ERROR"
  #     else
  #       which_cards.each do |card|
  #         @hand[card] = dealCard
  #       end
  #     end
  #   end
  # end
end
