class Game
end


class Deck
  # Using standard French 56-cards deck
  # attr_accessor :complete_deck
  attr_reader :complete_deck

  def initialize()
    @complete_deck = createInitialDeck
  end
  def createInitialDeck
    suits = ["Spades", "Hearts", "Diamonds", "Club"]
    type_cards = ["Ace", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
    @complete_deck = type_cards.product(suits)
    @complete_deck.shuffle()
  end

end

class Card < Deck
  def initialize(card)
    @card = card
  end

  def get_card()
    puts "#{@card[0]} of #{@card[1]}"
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
