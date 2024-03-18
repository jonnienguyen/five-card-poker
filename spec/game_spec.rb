#spec/game_spec.rb
require 'game'


RSpec.describe Game do
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
