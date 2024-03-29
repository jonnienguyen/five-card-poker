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

RSpec.describe Hand do
  let(:tester) {Player.new(["john"])}
  let(:test_hand) {Hand.new(tester)}
  describe "#hand_strength" do
    it "is Royal flush" do
      h = [["10", "Clubs"], ["Jack", "Clubs"], ["Queen", "Clubs"], ["King", "Clubs"], ["Ace", "Clubs"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Royal Flush")
    end
    it "is Straight flush" do
      h = [["6" ,"Diamonds"], ["7" ,"Diamonds"], ["8" ,"Diamonds"], ["9" ,"Diamonds"], ["10" ,"Diamonds"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Straight Flush")
    end
    it "is Four of a Kind" do
      h = [["9", "Clubs"], ["9", "Diamonds"], ["9", "Hearts"], ["9", "Spades"], ["1", "Dimonds"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Four of a Kind")
    end
    it "is Full house" do
      h = [["Ace", "Diamonds"], ["Ace", "Clubs"], ["Ace", "Spades"], ["7", "Spades"], ["7", "Hearts"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Full House")
    end
    it "is Flush" do
      h = [["3", "Diamonds"], ["8", "Diamonds"], ["6", "Diamonds"], ["King", "Diamonds"], ["10", "Diamonds"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Flush")
    end
    it "is Straight" do
      h = [["7", "Hearts"], ["8", "Diamonds"], ["9", "Clubs"],["10", "Hearts"], ["Jack", "Spades"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Straight")
    end
    it "is Three of a kind" do
      h = [["10", "Spades"], ["10", "Diamonds"], ["10", "Clubs"], ["6", "Hearts"], ["Ace", "Spades"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Three of a Kind")
    end
    it "is Two pair" do
      h = [["6", "Spades"], ["6", "Diamonds"], ["Queen", "Clubs"], ["Queen", "Hearts"], ["King", "Hearts"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("Two Pair")
    end
    it "is Pair" do
      h = [["Jack", "Diamonds"], ["Jack", "Spades"], ["2", "Clubs"], ["9", "Hearts"], ["King", "Spades"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("One Pair")
    end
    it "is High card" do
      h = [["King", "Hearts"], ["7", "Diamonds"], ["8", "Clubs"], ["Jack", "Spades"], ["10", "Hearts"]]
      test_hand.all_players_hand = [h]
      expect(test_hand.hand_strength(h)).to eq("High Card")
    end
  end
end

RSpec.describe Player do
  let(:fakePlayer) {Player.new("john", ["Ace of Spades", "7 of Diamonds", "9 of Club" "8 of Diamonds", "Ace of Club"])}

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

  describe "#discard" do
    it "prompt user for how many cards to discard" do
      allow(fakePlayer).to receive(:gets).and_return("3")
      expect(fakePlayer.discard).to eq 3
    end
    it "checks if user enter an invalid number" do
      allow(fakePlayer).to receive(:gets).and_return("4", "2")
      expect {fakePlayer.discard}.to output("(To john) How many card do you wish to discard (between 0 and 3)?\nSorry, enter an valid number of cards to discard:\n").to_stdout
      expect(fakePlayer.discard).to eq 2
    end
  end

end

RSpec.describe Game do
  let(:fakeGame) {Game.new(["john", "bob"])}
  # To get cards

  # before(:each) do
  #   fakeGame.start_game
  # end

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
  new_players = ["ada", "asa"]
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

  xdescribe "#next_turn" do
    it "Check next person turn" do
      fakeGame.next_turn
      expect(fakeGame.whose_turn.name).to match("bob")
    end
    it "Check for if it reachs end of players (should go back to first)" do
      fakeGame.next_turn
      fakeGame.next_turn
      expect(fakeGame.whose_turn.name).to match("john")
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
end
