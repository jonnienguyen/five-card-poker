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
