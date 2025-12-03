# spec/hand_spec.rb
require 'hand'
require 'player'
require 'card'

RSpec.describe Hand do
  describe "#evaluate_hand" do
    let(:hand_evaluator) { Hand.new }

    it "identifies Royal Flush" do
      royal_flush = [["10", "Clubs"], ["Jack", "Clubs"], ["Queen", "Clubs"],
                     ["King", "Clubs"], ["Ace", "Clubs"]]
      result = hand_evaluator.send(:evaluate_hand, royal_flush)
      expect(result).to eq([10, "Royal Flush"])
    end

    it "identifies Straight Flush" do
      straight_flush = [["6", "Diamonds"], ["7", "Diamonds"], ["8", "Diamonds"],
                        ["9", "Diamonds"], ["10", "Diamonds"]]
      result = hand_evaluator.send(:evaluate_hand, straight_flush)
      expect(result).to eq([9, "Straight Flush"])
    end

    it "identifies Four of a Kind" do
      four_of_a_kind = [["9", "Clubs"], ["9", "Diamonds"], ["9", "Hearts"],
                        ["9", "Spades"], ["1", "Diamonds"]]
      result = hand_evaluator.send(:evaluate_hand, four_of_a_kind)
      expect(result).to eq([8, "Four of a Kind"])
    end

    it "identifies Full House" do
      full_house = [["Ace", "Diamonds"], ["Ace", "Clubs"], ["Ace", "Spades"],
                    ["7", "Spades"], ["7", "Hearts"]]
      result = hand_evaluator.send(:evaluate_hand, full_house)
      expect(result).to eq([7, "Full House"])
    end

    it "identifies Flush" do
      flush = [["3", "Diamonds"], ["8", "Diamonds"], ["6", "Diamonds"],
               ["King", "Diamonds"], ["10", "Diamonds"]]
      result = hand_evaluator.send(:evaluate_hand, flush)
      expect(result).to eq([6, "Flush"])
    end

    it "identifies Straight" do
      straight = [["7", "Hearts"], ["8", "Diamonds"], ["9", "Clubs"],
                  ["10", "Hearts"], ["Jack", "Spades"]]
      result = hand_evaluator.send(:evaluate_hand, straight)
      expect(result).to eq([5, "Straight"])
    end

    it "identifies Three of a Kind" do
      three_of_a_kind = [["10", "Spades"], ["10", "Diamonds"], ["10", "Clubs"],
                         ["6", "Hearts"], ["Ace", "Spades"]]
      result = hand_evaluator.send(:evaluate_hand, three_of_a_kind)
      expect(result).to eq([4, "Three of a Kind"])
    end

    it "identifies Two Pair" do
      two_pair = [["6", "Spades"], ["6", "Diamonds"], ["Queen", "Clubs"],
                  ["Queen", "Hearts"], ["King", "Hearts"]]
      result = hand_evaluator.send(:evaluate_hand, two_pair)
      expect(result).to eq([3, "Two Pair"])
    end

    it "identifies One Pair" do
      one_pair = [["Jack", "Diamonds"], ["Jack", "Spades"], ["2", "Clubs"],
                  ["9", "Hearts"], ["King", "Spades"]]
      result = hand_evaluator.send(:evaluate_hand, one_pair)
      expect(result).to eq([2, "One Pair"])
    end

    it "identifies High Card" do
      high_card = [["King", "Hearts"], ["7", "Diamonds"], ["8", "Clubs"],
                   ["Jack", "Spades"], ["10", "Hearts"]]
      result = hand_evaluator.send(:evaluate_hand, high_card)
      expect(result).to eq([1, "High Card"])
    end
  end

  describe "#evaluate_all_hands" do
    it "evaluates all players' hands and stores results" do
      player1 = Player.new("Alice", [["Ace", "Spades"], ["Ace", "Hearts"],
                                      ["Ace", "Clubs"], ["King", "Spades"],
                                      ["Queen", "Hearts"]], 1000)
      player2 = Player.new("Bob", [["2", "Spades"], ["3", "Hearts"],
                                    ["4", "Clubs"], ["5", "Spades"],
                                    ["6", "Hearts"]], 1000)

      hand = Hand.new([player1, player2])
      hand.evaluate_all_hands

      expect(hand.results).to have_key("Alice")
      expect(hand.results).to have_key("Bob")
      expect(hand.results["Alice"][1]).to eq("Three of a Kind")
      expect(hand.results["Bob"][1]).to eq("Straight")
    end
  end

  describe "#winners" do
    it "returns the player(s) with the highest hand rank" do
      player1 = Player.new("Alice", [["10", "Clubs"], ["Jack", "Clubs"],
                                      ["Queen", "Clubs"], ["King", "Clubs"],
                                      ["Ace", "Clubs"]], 1000)
      player2 = Player.new("Bob", [["9", "Clubs"], ["9", "Diamonds"],
                                    ["9", "Hearts"], ["9", "Spades"],
                                    ["1", "Diamonds"]], 1000)

      hand = Hand.new([player1, player2])
      hand.evaluate_all_hands
      winners = hand.winners

      expect(winners).to have_key("Alice")
      expect(winners["Alice"][1]).to eq("Royal Flush")
    end

    it "returns multiple winners in case of a tie" do
      player1 = Player.new("Alice", [["Ace", "Spades"], ["King", "Spades"],
                                      ["Queen", "Spades"], ["Jack", "Spades"],
                                      ["10", "Spades"]], 1000)
      player2 = Player.new("Bob", [["Ace", "Hearts"], ["King", "Hearts"],
                                    ["Queen", "Hearts"], ["Jack", "Hearts"],
                                    ["10", "Hearts"]], 1000)

      hand = Hand.new([player1, player2])
      hand.evaluate_all_hands
      winners = hand.winners

      expect(winners.length).to eq(2)
      expect(winners).to have_key("Alice")
      expect(winners).to have_key("Bob")
    end
  end
end
