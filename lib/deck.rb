class Deck
  # Using standard French 56-cards deck (includes Ace)
  SUITS = ["Diamonds", "Clubs", "Hearts", "Spades"].freeze
  VALUES = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"].freeze

  attr_accessor :cards

  def initialize
    @cards = build_deck
  end

  def deal_card
    @cards.pop
  end

  def cards_remaining
    @cards.length
  end

  private

  def build_deck
    deck = VALUES.product(SUITS)
    deck.shuffle
  end
end
