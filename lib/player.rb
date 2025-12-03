class Player
  attr_accessor :name, :hand, :pot

  def initialize(name, hand = [], pot = 1000)
    @name = name
    @hand = hand
    @pot = pot # Set default
  end

  def discard
    # prompt player for card they wish to dicard
    puts "(To #{@name}) How many card do you wish to discard (between 0 and 3)?"
    num_cards = gets.chomp.to_i
    # Check if its between 0 and 3
    until (0..3).include?(num_cards)
      puts "Sorry, enter an valid number of cards to discard:"
      num_cards = gets.chomp.to_i
    end
    # Return an integer [0,3]
    return num_cards
  end

  def action
    menu =
    "
    Three Options:
    1. Fold: Discard hand, foreit the current pot
    2. See current bet (Call): See currnet bets, and match current highest bet
    3. Raise: Increase current highest bet
    "
    while true
      # Continues to prompt user for input if invalid;
      # else returns therefore ending loop
      # puts menu
      choice = gets.downcase.chomp

      case choice
      when "fold"
        return :fold
        break
      when "see"
        return :see
        break
      when "raise"
        return :raise
        break
      else
        puts "Invalid choice!"
      end
    end
  end

  def display_hand
    puts "\n(To #{@name}) here are your cards:"
    5.times do |i|
      c = Card.new(hand[i])
      puts "#{i+1} - #{c}"
    end
  end
end
