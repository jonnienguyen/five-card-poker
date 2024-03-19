class Game
end


class Deck
  # Using standard French 56-cards deck

  attr_accessor :complete_deck
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

  def dealCard
    one_card = @complete_deck.sample(1 + rand(@complete_deck.count))
    @complete_deck.pop(one_card)
    return one_card
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

class Player < Deck
  def initialize(hand, pot)
    @hand = hand
    @pot = pot
    # @choice = gets
  end

  def get_hand
    return @hand
  end
  def option()
    # Enter the number of the card
    if @choice.strip == "discard"
      puts @hand
      which_cards.split = gets
      if which_cards.length > 3
        puts "ERROR"
      else
        which_cards.each do |card|
          @hand[card] = dealCard
        end
      end
    end
  end

end
