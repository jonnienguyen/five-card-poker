class Hand
  HAND_RANKINGS = {
    royal_flush: [10, "Royal Flush"],
    straight_flush: [9, "Straight Flush"],
    four_of_a_kind: [8, "Four of a Kind"],
    full_house: [7, "Full House"],
    flush: [6, "Flush"],
    straight: [5, "Straight"],
    three_of_a_kind: [4, "Three of a Kind"],
    two_pair: [3, "Two Pair"],
    one_pair: [2, "One Pair"],
    high_card: [1, "High Card"]
  }.freeze

  attr_accessor :players
  attr_reader :results

  def initialize(players = [])
    @players = players
    @results = {} # Used to store each player's strength
  end

  def evaluate_all_hands
    @players.each do |player|
      @results[player.name] = evaluate_hand(player.hand)
    end
  end

  def winners
    highest_rank = @results.values.map { |result| result[0] }.max
    @results.select { |_, result| result[0] == highest_rank }
  end

  private

  def evaluate_hand(cards)
    card_values = convert_to_numeric(cards)
    suit_counts = count_suits(cards)
    value_counts = count_values(card_values)

    determine_hand_type(card_values, suit_counts, value_counts)
  end

  def determine_hand_type(values, suits, value_counts)
    max_suit_count = suits.values.max
    max_value_count = value_counts.values.max
    value_counts_array = value_counts.values.sort

    # Royal flush - 5 cards of same suits AND rank 10 to ace.
    return HAND_RANKINGS[:royal_flush] if royal_flush?(values, max_suit_count)
    # Straight flush - 5 cards of same suits; successive rank. should be 4 since max - min = 4
    return HAND_RANKINGS[:straight_flush] if straight_flush?(values, max_suit_count)
    # Four of a Kind - any 4 matching values
    return HAND_RANKINGS[:four_of_a_kind] if max_value_count == 4
    # Full house - 3 cards of same values; 2 cards of different values
    return HAND_RANKINGS[:full_house] if value_counts_array == [2, 3]
    # Flush - 5 cards of the same suit, values doesnt matter (tie based on rank)
    return HAND_RANKINGS[:flush] if max_suit_count == 5
    # Straight - 5 cards in sequence, more than 1 suit
    return HAND_RANKINGS[:straight] if straight?(values)
    # Three of a kind - 3 cards of the same rank in different rank
    return HAND_RANKINGS[:three_of_a_kind] if max_value_count == 3
    # Two pair - 2 sets of cards with the same values
    return HAND_RANKINGS[:two_pair] if two_pair?(value_counts)
    # One Pair - 2 same values
    return HAND_RANKINGS[:one_pair] if max_value_count == 2
    # High card - None of the above combinations; determined by the highest ranking card in hand
    return HAND_RANKINGS[:high_card]
  end

  def royal_flush?(values, max_suit_count)
    max_suit_count == 5 && values.sort == [10, 11, 12, 13, 14]
  end

  def straight_flush?(values, max_suit_count)
    max_suit_count == 5 && consecutive?(values)
  end

  def straight?(values)
    consecutive?(values) && values.uniq.length == 5
  end

  def two_pair?(value_counts)
    value_counts.values.count(2) == 2 && value_counts.keys.length == 3
  end

  def consecutive?(values)
    sorted_values = values.sort.uniq
    sorted_values.length == 5 && (sorted_values.max - sorted_values.min) == 4
  end

  def convert_to_numeric(cards)
    cards.map { |value, _| Card::FACE_VALUES[value] || value.to_i }
  end

  def count_values(numeric_values)
    numeric_values.uniq.each_with_object({}) do |value, hash|
      hash[value] = numeric_values.count(value)
    end
  end

  def count_suits(cards)
    cards.each_with_object(Hash.new(0)) do |(_, suit), hash|
      hash[suit] += 1
    end
  end
end
