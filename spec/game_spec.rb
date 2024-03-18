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
