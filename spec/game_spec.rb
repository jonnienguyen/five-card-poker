#spec/game_spec.rb
require 'game'

RSpec.describe Card do
  let(:cardEx) {Card.new(["Ace", "Spades"])}
  it "Get card info" do
    expect(cardEx) == "Ace of Spades"
  end
end

RSpec.describe Deck do
  let(:deckEx1) {Deck.new()}
  # Second deck used to check randomness of two decks.
  let(:deckEx2) {Deck.new()}
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

# RSpec.describe Hand do
#   describe "#decide_winner" do
#     it "is Royal flush" do
#     end
#     it "is Straight flush" do
#     end
#     it "is Four of a Kind" do
#     end
#     it "is Full house" do
#     end
#     it "is Flush" do
#     end
#     it "is Straight" do
#     end
#     it "is Three of a kind" do
#     end
#     it "is Two pair" do
#     end
#     it "is Pair" do
#     end
#     it "is High card" do
#     end
#   end
# end

RSpec.describe Player do
  let(:fakePlayer) {Player.new(["Ace of Spades", "7 of Diamonds", "9 of Club"])}

  describe "#action" do
    it "Should returns :fold" do
      allow(fakePlayer).to receive(:gets).and_return("fold")
      expect(fakePlayer.action).to eq(:fold)
    end
    it "Should returns :see" do
      allow(fakePlayer).to receive(:gets).and_return("see")
      expect(fakePlayer.action).to eq(:see)
    end
    it "Should returns :raise" do
      allow(fakePlayer).to receive(:gets).and_return("raise")
      expect(fakePlayer.action).to eq(:raise)
    end
    it "Check for invalid choices, and to prompt again" do
      allow(fakePlayer).to receive(:gets).and_return("xyz12ojasndoasnd\n", "raise\n")
      expect{fakePlayer.action}.to output(/Invalid choice!/).to_stdout
      expect(fakePlayer.action).to eq(:raise)
    end
  end

end

RSpec.describe Game do

  let(:fakeGame) {Game.new(["john", "bob"])}
  before(:each) do
    fakeGame.start_game
  end

  describe "#initialize" do
  it "Check number of players" do
    expect(fakeGame.players.length).to eq 2
  end
  it "Checks player info" do
    expect(fakeGame.players[0]) == "John"
    expect(fakeGame.players[0].hand.length).to eq 5
    expect(fakeGame.players[0].pot).to eq 1000
  end
  it "check each player hand are not the same" do
    expect(fakeGame.players[0].hand).to_not eq fakeGame.players[1].hand
  end
  it "Check number of cards" do
    expect(fakeGame.current_deck.complete_deck.length).to eq 46
  end
end

end
