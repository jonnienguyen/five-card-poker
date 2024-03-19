#spec/game_spec.rb
require 'game'


RSpec.describe Card do
  let(:cardEx) {Card.new(["Ace", "Spades"])}
  it "Reads card info" do
    expect(cardEx.get_card) == "Ace of Spades"

  end
end

RSpec.describe Deck do
  let(:deckEx1) {Deck.new()}
  # Second deck used to check randomness of two decks.
  let(:deckEx2) {Deck.new()}
  describe "#createDeck" do
      it "Check for correct number of cards created." do
        deckEx1.createInitialDeck
        expect(deckEx1.complete_deck.length).to eq 56
      end

      it "Check if cards are shuffled" do
        deckEx1.createInitialDeck
        deckEx2.createInitialDeck

        expect(deckEx1).to_not eq deckEx2
      end
  end
end

RSpec.describe Hand do
  describe "#decide_winner" do
    it "is Royal flush" do
    end
    it "is Straight flush" do
    end
    it "is Four of a Kind" do
    end
    it "is Full house" do
    end
    it "is Flush" do
    end
    it "is Straight" do
    end
    it "is Three of a kind" do
    end
    it "is Two pair" do
    end
    it "is Pair" do
    end
    it "is High card" do
    end
  end
end

RSpec.describe Game do
end

RSpec.describe Player do
  let(:fakePlayer) {Player.new(["Ace of Spades", "7 of Diamonds", "9 of Club"], 500)}
  it "inherits from Deck" do
    expect(Player.ancestors).to include(Deck)
  end
  it "Check card in hand is valid" do
    valid_hand = true
    (fakePlayer.get_hand).each do |single_card|
      single_card.split
      if @complete_deck.include(single_card.split(" of "))
        valid_hand False
        break
      end
    end
    expect(valid_hand).to be false
  end

  xit "Check raise pot amount" do
    fakePlayer.raise_pot(10)
    expect(fakePlayer.get_pot) == 490
  end

  xit "Check if player already chose discard" do
    fakePlayer.choice("discard")
    expect(fakePlayer.did_discard) == False
  end

  xit "If choice is discard - check discarded card logic" do
  end
end
