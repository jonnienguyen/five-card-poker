class Player
  VALID_ACTIONS = ["fold", "see", "raise"].freeze
  MAX_DISCARD = 3
  INITIAL_POT = 1000

  attr_accessor :name, :hand, :pot

  def initialize(name, hand = [], pot = INITIAL_POT)
    @name = name
    @hand = hand
    @pot = pot
  end

  def get_discard_count
    loop do
      puts "(To #{@name}) How many cards do you wish to discard (0-#{MAX_DISCARD})?"
      input = gets.chomp.to_i

      return input if (0..MAX_DISCARD).include?(input)
      puts "Invalid input. Please enter a number between 0 and #{MAX_DISCARD}."
    end
  end

  def get_action
    loop do
      puts "\n(To #{@name}) Choose an action: fold, see, or raise"
      choice = gets.downcase.chomp

      return choice.to_sym if VALID_ACTIONS.include?(choice)
      puts "Invalid choice! Please enter: #{VALID_ACTIONS.join(', ')}"
    end
  end

  def display_hand
    puts "\n(To #{@name}) Here are your cards:"
    @hand.each_with_index do |card, index|
      card_obj = Card.new(card)
      puts "#{index + 1} - #{card_obj}"
    end
  end
end
