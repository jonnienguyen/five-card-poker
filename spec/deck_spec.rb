# spec/deck_spec.rb
require 'deck'

RSpec.describe Deck do
  let(:deckEx1) { Deck.new() }
  # Second deck used to check randomness of two decks.
  let(:deckEx2) { Deck.new() }

  # Before hook to get the cards
  before(:each) do
    deckEx1.createInitialDeck
    deckEx2.createInitialDeck
  end

  describe "#createInitialDeck" do
    it "Checks correct number of cards created." do
      expect(deckEx1.complete_deck.length).to eq 56
    end

    it "Check if cards are shuffled" do
      expect(deckEx1).to_not eq deckEx2
    end
  end
end
