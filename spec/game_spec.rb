# spec/game_spec.rb
require 'game'

RSpec.describe Game do
  let(:fakeGame) { Game.new(["john", "bob"]) }

  describe "#initialize" do
    it "Check number of players" do
      expect(fakeGame.players.length).to eq 2
    end

    it "Check initial whose turn" do
      expect(fakeGame.whose_turn).to match("john")
    end

    it "Checks player info" do
      expect(fakeGame.players[0].name).to match("john")
      expect(fakeGame.players[0].hand.length).to eq 5
      expect(fakeGame.players[0].pot).to eq 1000
    end

    it "check each player hand are not the same" do
      expect(fakeGame.players[0].hand).to_not eq fakeGame.players[1].hand
    end

    # this is after it deals 5 card to the players (10 cards total)
    it "Check number of cards" do
      expect(fakeGame.current_deck.complete_deck.length).to eq 46
    end
  end

  describe "#create_and_deal" do
    let(:new_players) { ["ada", "asa"] }

    it "Creates players with correct names and check if they have 5 cards" do
      players = fakeGame.create_and_deal(new_players)
      expect(players.length).to eq 2
      # Iterate
      players.each do |player|
        expect(new_players.include?(player.name)).to eql true
        expect(player.hand.length).to eq 5
      end
    end

    it "Check the total number of cards left in deck" do
      expect(fakeGame.current_deck.complete_deck.length).to eq 46
    end
  end

  describe "#betting_round" do
    it "Removes player from game when folded" do
      allow(fakeGame.players[0]).to receive(:action).and_return(:fold)
      allow(fakeGame.players[1]).to receive(:action).and_return(:fold)
      fakeGame.betting_round

      expect(fakeGame.get_names("folded")).to include("john", "bob")
      expect(fakeGame.get_names("current")).not_to include("john", "bob")
      # Every players has folded so should be 0
      expect(fakeGame.players.length).to eq 0
    end

    it "Handles see action correctly" do
      # Stub the input for the betting amount, including the newline character to check for chomp
      allow(fakeGame.players[0]).to receive(:action).and_return(:fold)
      allow(fakeGame.players[1]).to receive(:action).and_return(:see)
      allow(fakeGame).to receive(:gets).and_return("100\n")
      # Was having trouble cause it's an infinite loop

      fakeGame.betting_round
      # allow(fakeGame).to receive(:gets).and_return("200\n")

      expect(fakeGame.bets["bob"]).to eq(100)
      # Since player 1 has folded check length of players left.
      expect(fakeGame.players.length).to eq 1
    end

    it "Raise bet correctly" do
      # Stub player actions and input for raising bets
      allow(fakeGame.players[0]).to receive(:action).and_return(:raise)
      allow(fakeGame.players[1]).to receive(:action).and_return(:raise)
      # dynamically simulate user input for each player
      allow(fakeGame).to receive(:gets).and_return("200\n", "400\n")
      fakeGame.betting_round

      # Check if the bets are correctly updated
      expect(fakeGame.bets[fakeGame.players[0].name]).to eq(200)
      expect(fakeGame.bets[fakeGame.players[1].name]).to eq(400)
    end
  end

  describe "#discard_round" do
    it "Prompt users for how many cards they wish to discard" do
      # Used to compare hand before and after

      hand1 = fakeGame.players[0].hand.dup
      puts "### #{hand1}"
      hand2 = fakeGame.players[1].hand.dup

      allow(fakeGame.players[0]).to receive(:discard).and_return(1)
      allow(fakeGame.players[1]).to receive(:discard).and_return(2)
      # three parameter give; each being the index for above
      allow(fakeGame).to receive(:gets).and_return("1", "1", "2")

      fakeGame.discard_round

      # Check at the index at which it update
      expect(fakeGame.players[0].hand[0]).to_not eq(hand1[0])
      expect(fakeGame.players[1].hand[0]).to_not eq(hand2[0])
      expect(fakeGame.players[1].hand[1]).to_not eq(hand2[1])
    end
  end

  describe "#showdown" do
    # I didnt know how to test this since my players' hand are random;
    # So I thought check if pot at the end is correct?
    it "distributes the pot to the winner(s)" do
      fakeGame.total_pots = 123

      fakeGame.showdown
      highest_pot = 0
      fakeGame.players.each do |x|
        if x.pot >= highest_pot
          highest_pot = x.pot
        end
      end

      expect([1061, 1123]).to include(highest_pot)
    end
  end
end
