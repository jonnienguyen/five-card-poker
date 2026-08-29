# spec/game_spec.rb
require 'game'
require 'player'
require 'deck'
require 'hand'
require 'card'

RSpec.describe Game do
  let(:game) { Game.new(["Alice", "Bob"]) }

  describe "#initialize" do
    it "creates correct number of players" do
      expect(game.players.length).to eq(2)
    end

    it "assigns correct player names" do
      names = game.players.map(&:name)
      expect(names).to include("Alice", "Bob")
    end

    it "deals 5 cards to each player" do
      game.players.each do |player|
        expect(player.hand.length).to eq(5)
      end
    end

    it "sets first player as current turn" do
      expect(game.current_turn_player.name).to eq("Alice")
    end

    it "initializes empty bets" do
      expect(game.bets).to be_empty
    end

    it "initializes zero pot" do
      expect(game.pot).to eq(0)
    end

    it "initializes no folded players" do
      expect(game.folded_players).to be_empty
    end

    it "creates deck with correct remaining cards" do
      expect(game.deck.cards_remaining).to eq(46)  # 56 - (5 * 2)
    end

    it "each player has starting pot of 1000" do
      game.players.each do |player|
        expect(player.pot).to eq(1000)
      end
    end

    it "each player's hand contains different cards" do
      expect(game.players[0].hand).not_to eq(game.players[1].hand)
    end
  end

  describe "#betting_round" do
    it "removes folded players from active game" do
      allow(game.players[0]).to receive(:get_action).and_return(:fold)
      allow(game.players[1]).to receive(:get_action).and_return(:fold)
      allow(game.players[0]).to receive(:display_hand)
      allow(game.players[1]).to receive(:display_hand)

      game.betting_round

      expect(game.players).to be_empty
      expect(game.folded_players.length).to eq(2)
    end

    it "handles see action" do
      allow(game.players[0]).to receive(:get_action).and_return(:fold)
      allow(game.players[1]).to receive(:get_action).and_return(:see)
      allow(game.players[0]).to receive(:display_hand)
      allow(game.players[1]).to receive(:display_hand)
      allow(game).to receive(:gets).and_return("100\n")

      game.betting_round

      expect(game.bets["Bob"]).to eq(100.0)
      expect(game.pot).to eq(100.0)
    end

    it "handles raise action" do
      allow(game.players[0]).to receive(:get_action).and_return(:raise)
      allow(game.players[1]).to receive(:get_action).and_return(:fold)
      allow(game.players[0]).to receive(:display_hand)
      allow(game.players[1]).to receive(:display_hand)
      allow(game).to receive(:gets).and_return("200\n")

      game.betting_round

      expect(game.bets["Alice"]).to eq(200.0)
    end

    it "prevents bet exceeding player's pot" do
      alice = game.players[0]
      bob = game.players[1]

      allow(alice).to receive(:get_action).and_return(:see)
      allow(bob).to receive(:get_action).and_return(:fold)
      allow(alice).to receive(:display_hand)
      allow(bob).to receive(:display_hand)

      # First input is invalid (exceeds pot), second is valid
      allow(game).to receive(:gets).and_return("2000\n", "500\n")

      game.betting_round

      expect(game.bets["Alice"]).to eq(500.0)
    end
  end

  describe "#discard_round" do
    it "replaces discarded cards with new ones from deck" do
      initial_cards = game.players[0].hand.dup

      allow(game.players[0]).to receive(:get_discard_count).and_return(2)
      allow(game.players[1]).to receive(:get_discard_count).and_return(0)
      allow(game.players[0]).to receive(:display_hand)
      allow(game.players[1]).to receive(:display_hand)
      allow(game).to receive(:gets).and_return("1\n", "2\n")

      game.discard_round

      expect(game.players[0].hand[0]).not_to eq(initial_cards[0])
      expect(game.players[0].hand[1]).not_to eq(initial_cards[1])
      # Third card should remain unchanged
      expect(game.players[0].hand[2]).to eq(initial_cards[2])
    end

    it "handles player discarding no cards" do
      allow(game.players[0]).to receive(:get_discard_count).and_return(0)
      allow(game.players[1]).to receive(:get_discard_count).and_return(0)
      allow(game.players[0]).to receive(:display_hand)
      allow(game.players[1]).to receive(:display_hand)

      original_hand = game.players[0].hand.dup
      game.discard_round

      expect(game.players[0].hand).to eq(original_hand)
    end
  end

  describe "#showdown" do
    it "calculates winners correctly" do
      game.pot = 200
      alice = game.players[0]
      bob = game.players[1]

      # Set up hands for testing
      allow_any_instance_of(Hand).to receive(:evaluate_all_hands)
      allow_any_instance_of(Hand).to receive(:results)
        .and_return({ "Alice" => [10, "Royal Flush"],
                     "Bob" => [1, "High Card"] })
      allow_any_instance_of(Hand).to receive(:winners)
        .and_return({ "Alice" => [10, "Royal Flush"] })

      expect { game.showdown }.to output(/winners/i).to_stdout
    end

    it "distributes pot equally among multiple winners" do
      game.players[0].pot = 1000
      game.players[1].pot = 1000
      game.pot = 400

      allow_any_instance_of(Hand).to receive(:evaluate_all_hands)
      allow_any_instance_of(Hand).to receive(:results)
        .and_return({ "Alice" => [10, "Royal Flush"],
                     "Bob" => [10, "Royal Flush"] })
      allow_any_instance_of(Hand).to receive(:winners)
        .and_return({ "Alice" => [10, "Royal Flush"],
                     "Bob" => [10, "Royal Flush"] })

      game.showdown

      # Each player should have received 200 (half the pot)
      expect(game.players[0].pot).to eq(1200)
      expect(game.players[1].pot).to eq(1200)
    end

    it "distributes pot to single winner" do
      game.players[0].pot = 1000
      game.players[1].pot = 900
      game.pot = 300

      allow_any_instance_of(Hand).to receive(:evaluate_all_hands)
      allow_any_instance_of(Hand).to receive(:results)
        .and_return({ "Alice" => [10, "Royal Flush"],
                     "Bob" => [1, "High Card"] })
      allow_any_instance_of(Hand).to receive(:winners)
        .and_return({ "Alice" => [10, "Royal Flush"] })

      game.showdown

      expect(game.players[0].pot).to eq(1300)
      expect(game.players[1].pot).to eq(900)
    end
  end
end
