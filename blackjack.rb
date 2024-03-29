# defining global values first

# suits, ranks and values
CARD_VALUES = 
  { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9, 
    'T' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 1 } # storing Ace as 1 initially
CARD_SUITS = ['C', 'D', 'H', 'S']
CARD_RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']

#create a deck of cards
deck = []

CARD_SUITS.each do |suit|
  CARD_RANKS.each do |rank|
    deck << "#{rank}#{suit}"
  end
end

# defining methods
def deal_card(hand, some_deck)
  new_card = some_deck.pop
  hand << new_card
  puts ""
  puts "Dealing card: #{new_card}"
end

def calculate_value(hand)
  hand_value = 0
  hand.each do |index|
    rank = index[0]
    value = CARD_VALUES["#{rank}"]
    hand_value += value
  end
  hand_value
end

#method to check if an Ace is in the hand
def is_ace(hand)
  ace = false
  hand.each do |index|
    rank = index[0]
    if rank == 'A'
      ace = true
    end
  end
  ace
end

def determine_winner(hand1, hand2, some_deck)
  hand1_value = calculate_value(hand1)
  hand2_value = calculate_value(hand2)
  #player's turn
  if hand1_value > 21
    puts "Your hand value is #{hand1_value}. You're busted!"
    exit
  elsif hand1_value == 21
    puts "You hit blackjack. You win!"
    exit
  else
    #check if an Ace is in player's hand
    if is_ace(hand1)
      if hand1_value + 10 == 21
        puts "You hit blackjack. You win!"
        exit
      elsif hand1_value + 10 < 21
        hand1_value = calculate_value(hand1) + 10
      end
    end
    puts "Your hand value is #{hand1_value}. Enter 'h' to hit or 's' to stand."
    action = gets.chomp
    #action's based on player's choice
    if action == 'h'
      deal_card(hand1, some_deck)
      puts ""
      puts "Your hand is now #{hand1}"
      determine_winner(hand1, hand2, some_deck) #call to the method itself to create a loop
    elsif action == 's'
      puts ""
      puts "Your final hand value is #{hand1_value}."
      # dealer's turn
      # check if an Ace is in dealer's hand
      if is_ace(hand2)
        if hand2_value + 10 <= 21
          hand2_value = calculate_value(hand2) + 10
        end
      end
      #check various options for the dealer
      while hand2_value < 17
        deal_card(hand2, some_deck)
        hand2_value = calculate_value(hand2)
        #ace case again
        if is_ace(hand2)
          if hand2_value + 10 <= 21
            hand2_value = calculate_value(hand2) + 10
          end
        end
      end
      puts ""
      if hand2_value > 21
        puts "Dealer is busted (#{hand2_value}). You win!"
      elsif hand2_value == 21
        puts "Dealer hit blackjack. Dealer wins!"
      else
        puts "Your final hand is: #{hand1}."
        puts "Dealer's final hand is: #{hand2}."
        puts ""      
        #compare and determine the winner
        puts  "Your hand value is #{hand1_value}, Dealer's hand value is #{hand2_value}."
        if hand1_value > hand2_value #dealer wins ties in my version
          puts "You win!"
        else
          puts "Dealer wins!"
        end
      end
    #if other key used (invalid action case)
    else
      puts "#{action} is not a valid action"
      puts ""
      determine_winner(hand1, hand2, some_deck)
    end
  end
end

#shuffle the deck before the start
deck.shuffle!

# ------------ GAMEPLAY STARTS HERE ---------------

puts ""
puts "Let's play some Blackjack!", ""

#initial deal (2 cards to both dealer and player)
player_hand = []
dealer_hand = []

player_hand << deck.pop
dealer_hand << deck.pop
player_hand << deck.pop
dealer_hand << deck.pop

player_hand_value = calculate_value(player_hand)
dealer_hand_value = calculate_value(dealer_hand)

puts "Your hand is: #{player_hand[0]} #{player_hand[1]}"
puts "Dealer's hand is: XX #{dealer_hand[1]}"

puts ""

determine_winner(player_hand, dealer_hand, deck)
