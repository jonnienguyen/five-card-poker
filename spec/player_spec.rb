# spec/player_spec.rb
require 'player'

RSpec.describe Player do
  let(:fakePlayer) { Player.new("john", ["Ace of Spades", "7 of Diamonds", "9 of Club" "8 of Diamonds", "Ace of Club"]) }

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
      expect { fakePlayer.action }.to output(/Invalid choice!/).to_stdout
      expect(fakePlayer.action).to eq(:raise)
    end
  end

  describe "#discard" do
    it "prompt user for how many cards to discard" do
      allow(fakePlayer).to receive(:gets).and_return("3")
      expect(fakePlayer.discard).to eq 3
    end

    it "checks if user enter an invalid number" do
      allow(fakePlayer).to receive(:gets).and_return("4", "2")
      expect { fakePlayer.discard }.to output("(To john) How many card do you wish to discard (between 0 and 3)?\nSorry, enter an valid number of cards to discard:\n").to_stdout
      expect(fakePlayer.discard).to eq 2
    end
  end
end
