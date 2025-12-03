# spec/card_spec.rb
require 'card'

RSpec.describe Card do
  let(:cardEx) { Card.new(["Ace", "Spades"]) }

  it "Get card info" do
    expect(cardEx) == "Ace of Spades"
  end
end
