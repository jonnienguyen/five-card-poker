# spec/player_spec.rb
require 'player'
require 'card'

RSpec.describe Player do
  let(:player) { Player.new("Alice", [], 1000) }

  describe "#initialize" do
    it "creates player with correct name" do
      expect(player.name).to eq("Alice")
    end

    it "initializes with empty hand" do
      expect(player.hand).to eq([])
    end

    it "initializes with default pot of 1000" do
      expect(player.pot).to eq(1000)
    end

    it "initializes with custom pot" do
      custom_player = Player.new("Bob", [], 2000)
      expect(custom_player.pot).to eq(2000)
    end
  end

  describe "#get_action" do
    it "returns :fold for fold input" do
      allow(player).to receive(:gets).and_return("fold")
      expect(player.get_action).to eq(:fold)
    end

    it "returns :see for see input" do
      allow(player).to receive(:gets).and_return("see")
      expect(player.get_action).to eq(:see)
    end

    it "returns :raise for raise input" do
      allow(player).to receive(:gets).and_return("raise")
      expect(player.get_action).to eq(:raise)
    end

    it "handles uppercase input" do
      allow(player).to receive(:gets).and_return("FOLD")
      expect(player.get_action).to eq(:fold)
    end

    it "re-prompts on invalid input" do
      allow(player).to receive(:gets).and_return("invalid", "raise")
      expect { player.get_action }.to output(/Invalid choice/).to_stdout
      expect(player.get_action).to eq(:raise)
    end
  end

  describe "#get_discard_count" do
    it "returns valid discard count" do
      allow(player).to receive(:gets).and_return("2")
      expect(player.get_discard_count).to eq(2)
    end

    it "accepts 0 discards" do
      allow(player).to receive(:gets).and_return("0")
      expect(player.get_discard_count).to eq(0)
    end

    it "accepts max discards (3)" do
      allow(player).to receive(:gets).and_return("3")
      expect(player.get_discard_count).to eq(3)
    end

    it "re-prompts on invalid input" do
      allow(player).to receive(:gets).and_return("5", "2")
      expect { player.get_discard_count }.to output(/Invalid input/).to_stdout
      expect(player.get_discard_count).to eq(2)
    end

    it "rejects negative numbers" do
      allow(player).to receive(:gets).and_return("-1", "1")
      expect { player.get_discard_count }.to output(/Invalid input/).to_stdout
      expect(player.get_discard_count).to eq(1)
    end
  end

  describe "#display_hand" do
    let(:player_with_hand) do
      Player.new("Charlie", [["Ace", "Spades"], ["King", "Hearts"]], 1000)
    end

    it "outputs player name" do
      expect { player_with_hand.display_hand }.to output(/Charlie/).to_stdout
    end

    it "outputs all cards in hand" do
      expect { player_with_hand.display_hand }
        .to output(/Ace of Spades.*King of Hearts/m).to_stdout
    end
  end
end
