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
