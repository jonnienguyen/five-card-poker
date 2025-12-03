# spec/hand_spec.rb
require 'hand'

RSpec.describe Hand do
  let(:tester) { Player.new(["john"]) }
  let(:test_hand) { Hand.new(tester) }

  describe "#determine_players_strength" do
    let(:other_tester1) { Player.new(["bob"], [["9", "Clubs"], ["9", "Diamonds"], ["9", "Hearts"], ["9", "Spades"], ["1", "Dimonds"]]) }
    let(:other_tester2) { Player.new(["ada"], [["10", "Clubs"], ["Jack", "Clubs"], ["Queen", "Clubs"], ["King", "Clubs"], ["Ace", "Clubs"]]) }
    let(:test_hand2) { Hand.new([other_tester1, other_tester2]) }

    it "Should return the proper result of each players' strength" do
      test_hand2.determine_players_strength
      expect(test_hand2.players_result).to eq({ other_tester2.name => [10, "Royal Flush"], other_tester1.name => [8, "Four of a Kind"] })
    end
  end

  describe "#hand_strength" do
    it "is Royal flush" do
      h = [["10", "Clubs"], ["Jack", "Clubs"], ["Queen", "Clubs"], ["King", "Clubs"], ["Ace", "Clubs"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([10, "Royal Flush"])
    end

    it "is Straight flush" do
      h = [["6", "Diamonds"], ["7", "Diamonds"], ["8", "Diamonds"], ["9", "Diamonds"], ["10", "Diamonds"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([9, "Straight Flush"])
    end

    it "is Four of a Kind" do
      h = [["9", "Clubs"], ["9", "Diamonds"], ["9", "Hearts"], ["9", "Spades"], ["1", "Dimonds"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([8, "Four of a Kind"])
    end

    it "is Full house" do
      h = [["Ace", "Diamonds"], ["Ace", "Clubs"], ["Ace", "Spades"], ["7", "Spades"], ["7", "Hearts"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([7, "Full House"])
    end

    it "is Flush" do
      h = [["3", "Diamonds"], ["8", "Diamonds"], ["6", "Diamonds"], ["King", "Diamonds"], ["10", "Diamonds"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([6, "Flush"])
    end

    it "is Straight" do
      h = [["7", "Hearts"], ["8", "Diamonds"], ["9", "Clubs"], ["10", "Hearts"], ["Jack", "Spades"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([5, "Straight"])
    end

    it "is Three of a kind" do
      h = [["10", "Spades"], ["10", "Diamonds"], ["10", "Clubs"], ["6", "Hearts"], ["Ace", "Spades"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([4, "Three of a Kind"])
    end

    it "is Two pair" do
      h = [["6", "Spades"], ["6", "Diamonds"], ["Queen", "Clubs"], ["Queen", "Hearts"], ["King", "Hearts"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([3, "Two Pair"])
    end

    it "is Pair" do
      h = [["Jack", "Diamonds"], ["Jack", "Spades"], ["2", "Clubs"], ["9", "Hearts"], ["King", "Spades"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([2, "One Pair"])
    end

    it "is High card" do
      h = [["King", "Hearts"], ["7", "Diamonds"], ["8", "Clubs"], ["Jack", "Spades"], ["10", "Hearts"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq([1, "High Card"])
    end
  end
end
