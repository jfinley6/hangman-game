require 'faker'
require 'colorize'

class String
  ##Checks to see if 
  def is_integer?
    self.to_i.to_s == self
  end
end

class Game

  ##initial variables can be found in private method setup found below
  def initialize
    setup
  end

  ##Sets up the initial variables and draws the game on the page
  def start
    puts `clear`
    setup
    write_empty_teaser
    render_ascii_art
    puts
    puts " " + "Try to guess the word in 6 guesses or less...".colorize(:color => :white, :background => :blue)
    puts
    puts draw
    puts
    puts " " + "The word you are trying to guess has #{@word.length} letters".colorize(:color => :white, :background => :blue)
    puts
    puts "   #{@teaser}"
    puts
    play
  end

  ##Starts the game and prompts the player to enter a letter
  def play
    enter_a_letter
    player_guess
  end

  ##Displays ascii art for title
  def render_ascii_art
    puts File.read("ascii.txt").colorize(:green)
  end

  ##Shows the player an empty teaser for the word at the start of the game
  def write_empty_teaser
    @word.split("").each { |i|
      @teaser += " _ "
    }
  end

  ##After making a guess, the player is presented with a new teaser that shows any correct guesses
  def update_teaser
    @teaser = ""
    @correct_answer = ""
    @word.split("").each { |i|
      if @correct_letters.include? i
        @teaser += " #{i.colorize(:color => :green)} "
        @correct_answer += i
      else
        @teaser += " _ "
        @correct_answer += ""
      end
    }
  end

  ##draws the word teaser to the page
  def draw_teaser
    puts
    puts "     #{@teaser}"
    puts 
  end

  ##After making a guess this will be displayed on the screen
   def enter_a_letter
    puts " " + "Please enter a letter".colorize(:color => :white, :background => :blue)
   end

   ##If a guess is not a letter or has already been used, redraw the page
   def try_again
    draw
    draw_teaser
    puts "  " + "Used Letters".underline
    print_used_letters
    puts
    puts
    enter_a_letter
    player_guess
   end

  ##Takes in a user input
  def player_guess
    puts
    guess = gets.chomp.downcase

    if @letters.include? guess
      puts `clear`
      letter_exists(guess)
    elsif guess.is_integer?
      puts `clear`
      render_ascii_art
      puts
      puts "  You can't put a number!".colorize(:red)
      try_again
    elsif guess.length > 1
      puts `clear`
      render_ascii_art
      puts
      puts "  Your guess should only have one character!".colorize(:red)
      try_again
    else
      puts `clear`
      render_ascii_art
      puts
      puts "  That letter has already been used".colorize(:red)
      try_again
    end
  end

  ##sorts the used letters alphabetically and prints them to the page
  def print_used_letters
    @used_letters = @used_letters.sort { |a, b| a <=> b }
    @used_letters.each { |l| print " #{l} " }
  end

  ##Checks to see if the letter has already been guessed
  def letter_exists(guess)
    if @word.include? guess
      @used_letters.push(guess)
      @correct_letters.push(guess)
      filter_letters(guess)
      render_ascii_art
      puts
      puts "  " +"That's correct!".colorize(:green)
      update_teaser
      draw
      draw_teaser
      puts "  " + "Used Letters".underline
      print_used_letters
      puts
      puts
      has_won?
    else
      @incorrect_answers += 1
      @used_letters.push(guess)
      filter_letters(guess)
      has_lost?
      render_ascii_art
      puts
      puts "  That's not correct!".colorize(:red)
      update_teaser
      draw
      draw_teaser
      puts "  " + "Used Letters".underline
      print_used_letters
      puts
      puts
      enter_a_letter
      player_guess
    end
  end

  ##Filters out a letter from @letters when a guess is made
  def filter_letters(guess)
    @letters.delete(guess)
  end

  ##Lets the player start the game over after winning or losing
  def play_again?
    puts "  " + "Play again? (y/n)"
    decide = gets.chomp
    if decide == "y"
      start
    elsif decide == "n"
      puts `clear`
      abort
    else 
      play_again?
    end
  end

  ##After making a guess, checks to see if the player won
  def has_won?
    if @correct_answer == @word
      puts "  " + "You win!"
      puts
      play_again?
    else
      enter_a_letter
      player_guess
    end
  end

  ##Checks to see if the player has lost
  def has_lost?
    if @incorrect_answers == 6
      render_ascii_art
      puts
      puts "  " + "You've Lost!".colorize(:red)
      draw
      puts 
      puts "  " + "The correct word was #{@word.capitalize.colorize(:green)}"
      puts
      play_again?
    end
  end

  ##Draws the hangman on the screen depending on how many incorrect guesses
  def draw
    case @incorrect_answers
    when 0
      puts "     ______"
      puts "    |      |"
      puts "           |"
      puts "           |"
      puts "           |"
      puts "           |"
    when 1
      puts "     ______"
      puts "    |      |"
      puts "   (00)    |"
      puts "           |"
      puts "           |"
      puts "           |"
    when 2
      puts "     ______"
      puts "    |      |"
      puts "   (00)    |"
      puts "    ||     |"
      puts "           |"
      puts "           |"
    when 3
      puts "     ______"
      puts "    |      |"
      puts "   (00)    |"
      puts "   \\||     |"
      puts "           |"
      puts "           |"
    when 4
      puts "     ______"
      puts "    |      |"
      puts "   (00)    |"
      puts "   \\||/    |"
      puts "           |"
      puts "           |"
    when 5
      puts "     ______"
      puts "    |      |"
      puts "   (00)    |"
      puts "   \\||/    |"
      puts "    /      |"
      puts "           |"
    when 6
      puts "     ______"
      puts "    |      |"
      puts "   (xx)    |"
      puts "   \\||/    |"
      puts "    /\\     |"
      puts "           |"
    end
  end

  private

  def setup
    @correct_letters = []
    @word = Faker::Verb.base
    @teaser = ""
    @correct_answer = ""
    @letters = ('a'..'z').to_a
    @incorrect_answers = 0
    @used_letters = []
  end

end

game = Game.new
game.start