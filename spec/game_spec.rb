#spec/game_spec.rb
require 'game'


RSpec.describe Game do
end


RSpec.describe Deck do
  let(:deckEX) {Deck.new()}

  describe "#createDeck" do
      it "Check for correct number of cards created." do
        deckEX.createInitialDeck
        expect(deckEX.complete_deck.length).to eq 56
      end
  end
end
