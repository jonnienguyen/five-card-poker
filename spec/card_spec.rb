# spec/card_spec.rb
require 'card'

RSpec.describe Card do
  describe "#initialize" do
    let(:card) { Card.new(["Ace", "Spades"]) }

    it "creates a card with correct value" do
      expect(card.value).to eq("Ace")
    end

    it "creates a card with correct suit" do
      expect(card.suit).to eq("Spades")
    end

    it "raises error for invalid suit" do
      expect { Card.new(["Ace", "InvalidSuit"]) }.to raise_error(ArgumentError)
    end
  end

  describe "#numeric_value" do
    it "returns numeric value for face cards" do
      expect(Card.new(["Jack", "Hearts"]).numeric_value).to eq(11)
      expect(Card.new(["Queen", "Hearts"]).numeric_value).to eq(12)
      expect(Card.new(["King", "Hearts"]).numeric_value).to eq(13)
      expect(Card.new(["Ace", "Hearts"]).numeric_value).to eq(14)
    end

    it "returns numeric value for number cards" do
      expect(Card.new(["5", "Clubs"]).numeric_value).to eq(5)
      expect(Card.new(["10", "Diamonds"]).numeric_value).to eq(10)
    end
  end

  describe "#to_s" do
    it "formats card correctly" do
      card = Card.new(["Ace", "Spades"])
      expect(card.to_s).to eq("Ace of Spades")
    end
  end
end
