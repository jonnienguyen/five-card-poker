class Card

  attr_reader :value, :suit
  # Pass in a unformatted card (array)
  def initialize(card)
    @value = card[0]
    @suit = card[1]
  end
  # For easier output; format card
  def to_s
    "#{@value} of #{@suit}"
  end
end
