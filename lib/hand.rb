class Hand
  attr_accessor :all_players_hand, :players_result
  def initialize(all_players_hand=[])
    # Pass in all players from Game
    @all_players_hand = all_players_hand
    # Used to store each player's strength
    @players_result = {}
  end

  def determine_players_strength
    # Iterate and gets each player's strength then store it
    @all_players_hand.each do |p|
      result = hand_strength(p.hand)
      # result is a array: (0) int to determine winner at end; (1) name of hand strength
      @players_result[p.name] = result
    end

  end

  def hand_strength(p_hand)
    sorted_hand = sort_hand(p_hand) # Sort the player's hand by values (and replace with an integer)
    values_order = sorted_hand.map {|value| value[0]} # 1d sorted array of values (should be all integers)
    # map into 2d hash for occurence; then flatten into 1d hash
    values_count = values_order.uniq.map { |x| {x=>values_order.count(x)} }.reduce({}, :merge)
    suits_count = get_suits(sorted_hand) # Get hash of occurence of each suits
    # puts values_order
    # puts values_count
    # puts suits_count

    # Royal flush - 5 cards of same suits AND rank 10 to ace.
    if suits_count.values.max == 5 && (values_order == [10, 11, 12, 13, 14])
      return [10, "Royal Flush"]
    # Straight flush - 5 cards of same suits; successive rank. should be 4 since max - min = 4
    elsif suits_count.values.max == 5 && (values_order.max - values_order.min == 4) && values_order.uniq.length == 5
      return [9, "Straight Flush"]
    # Four of a Kind - any 4 matching values
    elsif values_count.values.max == 4
      return [8, "Four of a Kind"]
    # Full house - 3 cards of same values; 2 cards of different values
    elsif values_count.values.sort == [2, 3]
      return [7, "Full House"]
    # Flush - 5 cards of the same suit, values doesnt matter (tie based on rank)
    elsif suits_count.values.max == 5
      return [6, "Flush"]
    # Straight - 5 cards in sequence, more than 1 suit
    elsif values_order.max - values_order.min == 4 && values_order.uniq.length == 5
      return [5, "Straight"]
    # Three of a kind - 3 cards of the same rank in different rank
    elsif values_count.values.max == 3
      return [4, "Three of a Kind"]
    # Two pair - 2 sets of cards with the same values
    elsif values_count.values.count(2) == 2 && values_count.keys.length == 3
      return [3, "Two Pair"]
    # One Pair - 2 same values
    elsif values_count.values.count(2) == 1
      return [2, "One Pair"]
    # High card - None of the above combinations; determined by the highest ranking card in hand
    else
      return [1, "High Card"]
    end
  end

  def winners
    # Since determine_players_strength sorted by highest already
    highest_rank = @players_result.values[0][0]
    # Gets a list of of winner(s)
    the_winners = @players_result.filter {|k, v| v[0] == highest_rank}
    return the_winners
  end

  private

  # Helper to sort hand AND values to integer
  def sort_hand(h)
    custom_sort_order = {
    "Jack" => 11,
    "Queen" => 12,
    "King" => 13,
    "Ace" => 14
  }
    # sorted_h = h.sort_by { |value, suit| custom_sort_order[value] || value.to_i }
    sorted_h = h.map do |value, suit|
      [custom_sort_order[value] || value.to_i, suit]
    end
    return sorted_h.sort
  end
  # Helper to get suits occurence
  def get_suits(h)
    suit_counts = Hash.new(0)
    h.each do |card|
      value, suit = card
      suit_counts[suit] += 1
    end
    return suit_counts
  end
end
