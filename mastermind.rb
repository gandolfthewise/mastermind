##
#Mastermind a game where the player/computer chooses 4 colours in a row as a 
#code to break. The other player is then allowed 12 turns to try to guess the 
#correct code. With each guess a white response indicates the correct colour 
#but in the wron position while black means the correct position and colour. 
#If there are duplicate colours they cannot be awared a response of more than
#what exists in the hidden code. The program will create a hidden code and then
#ask the player for an input of a guessed code and then returning the board of
#each guess and it's corresponding feedback.
##
require 'pry'
class Mastermind


 def initialize
  @color_array=["red", "green", "blue", "yellow", "purple", "orange"]
  @hidden_code = []
  @player_hidden_code = []
  @current_guess = nil
  @guess_array = []
  @turns = 12
  @game_type_choice = nil
 end
#create hidden code
  def create_hidden_code
    4.times do
      @hidden_code.push(@color_array.sample)
    end
  end
#Has the user incorrectly inputted their guess
def input_correct?(guess)
  guess.all? {|i| @color_array.any?{|x| x==i}}
end
#Does the guess == the hidden code
def correct_guess?(guess)
  guess == @hidden_code ? true : false
end
#Provide feedback for the current guess cycle through each element of array
#first loop if correct colour/position place black and remove pin from guess&code
#Second loop if colour exists in code place white and remove pin from guess&code
#else place blank
def guess_feedback(guess)
  temp_hidden_code = []
  if @game_type_choice == "cb"
  temp_hidden_code.concat(@hidden_code)
  else
    temp_hidden_code.concat(@player_hidden_code)
  end
  for i in 0..3
    if guess[i] == temp_hidden_code[i]
      guess[i] = "black"
      temp_hidden_code[i] = "taken"
    end
  end
  for i in 0..3
    if temp_hidden_code.index(guess[i]) != nil
      temp_hidden_code[temp_hidden_code.index(guess[i])] = "taken"
      guess[i] = "white"
    end
  end
  for i in 0..3
    if guess[i] != "black" && guess[i] != "white" 
      guess[i] = "blank" 
    end
  end
  guess
end

#Print the current guess attempts and their feedback, black for correct position
#and colour, white for correct colour but not right position blank for neither
def print_board(guess_given)
  print "#{guess_feedback(guess_given)} \n"
end
#ask for players guess
def player_guess
  print "What four colours do you think? turns:#{@turns}\n"
  @current_guess = gets.chomp.split(" ")
  #check input has been correctly inputed
  if input_correct?(@current_guess) == false
    print "Incorrect input please try again you still have #{@turns} left\n"
    player_guess
  #Does the guess match the hidden code
  elsif correct_guess?(@current_guess)
    print "Correct the hidden code was: #{@current_guess}"
  #Has the player run out of turns
  elsif @turns<=0
    print "Sorry no more turns left the hidden code was: #{@hidden_code}"
  else
    @turns -= 1
    @guess_array.push(@current_guess.join(" ").split(" "))
    print_board(@current_guess)
    player_guess
  end
end

def random_code
  code = []
  4.times do
    code.push(@color_array.sample)
  end
  code
end

def computer_guess
  #Create random guess for computers turn
  current_computer_guess = random_code
  print "Hmm is it #{current_computer_guess}\n"
  #Check if guess is correct and return feedback
  if correct_guess?(current_computer_guess)
    print "Computer Wins :)"
  elsif @turns<=0
    print "Opps no more turns left computer loses\n"
  else
    @turns -= 1
    print_board(current_computer_guess)
    computer_guess
  end
end

def new_game
  #Ask player if they want to create the hidden code or 
  print "Do you want to be the codemaker type \'cm\' or codebreaker type \'cb\'"
  @game_type_choice = gets.chomp
  if @game_type_choice == "cb"
  #Print the instructions of the game
  print "The computer has created a hidden code and your job is to type four colours to which you will recieve feedback. You will be given 12 tries\n"
  create_hidden_code
  player_guess
  elsif @game_type_choice == "cm"
    #Computer to guess randomly through it's turns
    print "Please type four colours for your code\n"
    @player_hidden_code.concat(gets.chomp.split(" "))
    computer_guess
  else
    new_game
  end
end
end
  #is the guess correct 
  #if right print winning message
  #if wrong print current board of guesses and corresponding feedback
current_game = Mastermind.new()
current_game.new_game()