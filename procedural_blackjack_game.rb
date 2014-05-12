# Procedural Blackjack Game

def calculate_total_points(cards)
  # keep only cards info
  array = cards.map{|e| e[1]}

  # calculate
  total_points = 0
  array.each { |e| total_points += numerate(e) } 

  # correct for 'A'
  array.select{|e| e == 'A'}.count.times do
    total_points -= 10 if total_points > 21
  end

  total_points
end

def numerate(card)
  if card == 'A'
    11
  elsif card.to_i == 0
    10
  else
    card.to_i
  end
end

def once_again?
  # exit or one more time
  puts 'Once again? Y - Yes; N - No.'
  anwser = gets.chomp
  puts "--"

  if ['Y', 'y'].include?(anwser)
    start_game
  elsif ['N', 'n'].include?(anwser)
    puts 'Bye!'
    exit
  else
    puts "You must enter Y or N."
    once_again?
  end  
end

def win?(player)
  # calculate & show points
  player[:total_points] = calculate_total_points(player[:cards])
  puts "#{player[:name]}'s cards: #{player[:cards]}, total points: #{player[:total_points]}"

  # judge
  if player[:total_points] == 21
    puts "#{player[:name]} win!"
    once_again?
  elsif player[:total_points] > 21
    puts "#{player[:name]} bust!"
    once_again?
  end
end

def start_game
  # define variables
  suits = ['S', 'H', 'D', 'C']
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  deck =  suits.product(cards).shuffle
  player = {name: $player_name, total_points: 0, cards: []}
  dealer = {name: 'Dealer', total_points: 0, cards: []}

  # deal cards
  player[:cards] << deck.pop
  dealer[:cards] << deck.pop
  player[:cards] << deck.pop
  dealer[:cards] << deck.pop

  win?(player)
  win?(dealer)

  # player's turn
  while player[:total_points] < 21
    puts 'Hit or Stay? H - Hit; S - Stay'
    action = gets.chomp
    puts "--"

    if ['H', 'h'].include?(action) # Hit
      new_card = deck.pop
      player[:cards] << new_card
      puts "Dealing card for you, #{player[:name]}: #{new_card}"
    elsif ['S', 's'].include?(action) # Stay 
      puts "You chose to stay."
      break
    else      
      puts "You must enter H or S."
      next
    end

    win?(player)
  end

  # dealer's turn
  while dealer[:total_points] < 17 # Hit
    new_card = deck.pop
    puts "Dealing card for dealer: #{new_card}"
    dealer[:cards] << new_card
    win?(dealer)
  end

  # compare hands
  puts "#{player[:name]}'s cards: #{player[:cards]}, total points: #{player[:total_points]}"

  if dealer[:total_points] > player[:total_points]
    puts "#{dealer[:name]} wins!"
  elsif dealer[:total_points] < player[:total_points]
    puts "#{player[:name]} wins!"
  else
    puts "It's a tie!"
  end

  once_again?
end

# welcome & get player's name 
puts "Welcome to Blackjack Game!"
puts "Enter your name, please."
$player_name = gets.chomp
puts "Hi, #{$player_name}. Let's start."
puts "--"

# start
start_game