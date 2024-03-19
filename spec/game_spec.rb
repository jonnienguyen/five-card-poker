#spec/game_spec.rb
require 'game'

RSpec.describe Game do
  let(:fakeGame) {Game.new([["John", 100], ["Bob", 50]])}
  describe "#initialize" do
  it "Check number of players" do
    expect(fakeGame.num_players.length).to eq 2
  end
  it "Check players info" do
    expect(fakeGame.num_players[0].name) == "John"
    expect(fakeGame.num_players[0].hand.length).to eq 5
    expect(fakeGame.num_players[0].pot).to eq 100
  end
  it "check each player hand are not the same" do
    expect(fakeGame.num_players[0].hand).to_not eq fakeGame.num_players[1].hand
  end
  it "Check number of cards" do
    expect(fakeGame.current_deck.complete_deck.length).to eq 46
  end
end

end

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

RSpec.describe Player do
  let(:fakePlayer) {Player.new(["Ace of Spades", "7 of Diamonds", "9 of Club"], 500)}
  xit "inherits from Deck" do
    expect(Player.ancestors).to include(Deck)
  end
  xit "Check card in hand is valid" do
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
