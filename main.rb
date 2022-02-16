# frozen_string_literal: true

# Creates a new human player, role can be creator or guesser
class Human
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def pick_secret
    puts 'Please choose a secret code! A 4 number digits between 1 and 6 code.'
    secret = gets.split('').map(&:to_i).delete_if(&:zero?)
    if secret.all? { |number| number.between?(1, 6) } && secret.length == 4
      secret
    else
      puts 'Wrong Input'
      pick_secret
    end
  end

  def guess_secret
    puts 'Input your guess! It should be a 4 digit number composed by numbers between 1 and 6!'
    guess = gets.split('').map(&:to_i).delete_if(&:zero?)
    if guess.all? { |number| number.between?(1, 6) } && guess.length == 4
      guess
    else
      puts 'Wrong Input'
      guess_secret
    end
  end
end

# Creates a new computer player, role can be creator or guesser
class Computer
  attr_reader :name

  def initialize
    choices = [1, 2, 3, 4, 5, 6]
    @possible_guesses = choices.repeated_permutation(4).to_a
    @last_guess = []
    @name = 'Jarvas the Computer'
  end

  def pick_secret
    secret = []
    4.times do
      secret << rand(1..6)
    end
    secret
  end

  def guess_secret
    sleep 1
    secret = if @last_guess.empty?
               [1, 1, 2, 2]
             else
               @possible_guesses[0]
             end
    @last_guess = secret
    secret
  end

  def delete_possible_guesses(right_position, right_color)
    @possible_guesses.delete(@last_guess)
    new_possible_guesses = []
    @possible_guesses.each do |possible_guess|
      right_pos = 0
      right_col = 0
      @last_guess.each_with_index do |number, index|
        right_pos += 1 if possible_guess[index].eql?(number)
        right_col += 1 if possible_guess.include?(number) && possible_guess[index].eql?(number) == false
      end
      new_possible_guesses << possible_guess if right_pos.eql?(right_position) && right_col >= right_color
    end
    @possible_guesses = new_possible_guesses
  end
end

# Creates a new board
class Board
  def print_guess(guess)
    puts "Guess: #{guess.join}"
  end

  def print_hints(right_position, right_color)
    puts "Hints: #{right_position.join} #{right_color.join}"
  end
end

# Contains the game logic
class Game
  def initialize
    @winner = false
    @round = 1
  end

  def play
    game_setup
    @board = Board.new
    store_secret
    play_round while @winner.eql?(false) && @round < 13
    declare_winner
  end

  def game_setup
    puts 'Rules!'
    create_players(human_name, human_role)
    puts "#{@maker.name} will be the Maker and #{@breaker.name} will be the Breaker!"
  end

  def human_name
    puts "Hello Human, what's your name?"
    gets.chomp
  end

  def human_role
    puts 'Input 0 if you want to be the Maker or 1 if you want to be the Breaker'
    gets.to_i
  end

  def create_players(name, role)
    if role.zero?
      @maker = Human.new(name)
      @breaker = Computer.new
    else
      @maker = Computer.new
      @breaker = Human.new(name)
    end
  end

  def play_round
    check_guess
    @round += 1
  end

  def ask_guess
    @guess = @breaker.guess_secret
    @board.print_guess(@guess)
  end

  def check_guess
    ask_guess
    if @secret.eql?(@guess)
      @winner = true
    else
      @hinted = []
      give_feedback
    end
  end

  def give_feedback
    @board.print_hints(right_position, right_color)
    @breaker.delete_possible_guesses(right_position.length, right_color.length) if @breaker.instance_of?(Computer)
  end

  def right_position
    hint = []
    @guess.each_with_index do |guess_number, index|
      next unless @secret[index].eql?(guess_number)

      hint << 'X'
      @hinted << guess_number
    end
    hint
  end

  def right_color
    hint = []
    @guess.each do |guess_number|
      hint << '?' if @secret.include?(guess_number) && @hinted.include?(guess_number) == false
    end
    hint
  end

  def declare_winner
    if @winner
      puts "Code Found! #{@breaker.name} is the Winner!"
    else
      puts "Code not Found! #{@maker.name} is the Winner!"
    end
  end

  private

  def store_secret
    @secret = @maker.pick_secret
  end
end

game = Game.new
game.play
