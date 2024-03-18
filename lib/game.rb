class Game
end


class Deck
  # Using standard French 56-cards deck
  attr_accessor :complete_deck
  def initalize()
    @complete_deck = []
  end
  def createInitialDeck
    suits = ["Spades", "Hearts", "Diamonds", "Club"]
    cards = ["Ace", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
    @complete_deck = suits.product(cards)
  end
end


class Card

end
