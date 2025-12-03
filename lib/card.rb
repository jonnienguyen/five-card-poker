class Card
  FACE_VALUES = { "Jack" => 11, "Queen" => 12, "King" => 13, "Ace" => 14 }.freeze
  VALID_SUITS = ["Diamonds", "Clubs", "Hearts", "Spades"].freeze

  attr_reader :value, :suit

  def initialize(card)
    @value = card[0]
    @suit = card[1]
    validate_card
  end

  def numeric_value
    FACE_VALUES[@value] || @value.to_i
  end

  def to_s
    "#{@value} of #{@suit}"
  end

  private

  def validate_card
    raise ArgumentError, "Invalid suit: #{@suit}" unless VALID_SUITS.include?(@suit)
  end
end
