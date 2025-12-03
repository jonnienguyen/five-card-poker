# spec/deck_spec.rb
require 'deck'

RSpec.describe Deck do
  describe "#initialize" do
    it "creates a deck with 56 cards" do
      deck = Deck.new
      expect(deck.cards.length).to eq(56)
    end

    it "shuffles cards on creation" do
      deck1 = Deck.new
      deck2 = Deck.new
      expect(deck1.cards).not_to eq(deck2.cards)
    end
  end

  describe "#deal_card" do
    let(:deck) { Deck.new }

    it "removes and returns a card from the deck" do
      initial_count = deck.cards_remaining
      card = deck.deal_card
      expect(card).to be_an(Array)
      expect(deck.cards_remaining).to eq(initial_count - 1)
    end

    it "deals different cards on successive calls" do
      card1 = deck.deal_card
      card2 = deck.deal_card
      expect(card1).not_to eq(card2)
    end
  end

  describe "#cards_remaining" do
    let(:deck) { Deck.new }

    it "returns the correct count of remaining cards" do
      expect(deck.cards_remaining).to eq(56)
      deck.deal_card
      expect(deck.cards_remaining).to eq(55)
    end
  end
end
