# frozen_string_literal: true

# require 'pry-byebug'

# Creates a new human player, role can be creator or guesser
class Human
  attr_accessor :name, :role

  def initialize(name)
    @name = name
  end

  def pick_secret
    gets.split('').map(&:to_i).delete_if(&:zero?)
  end

  def guess_secret
    puts 'Input your guess! It should be a 4 digit number composed by numbers between 1 and 6!'
    guess = gets.split('').map(&:to_i).delete_if(&:zero?)
    if guess.all? { |number| number.between?(1, 6) } && guess.length == 4
      guess
    else
      puts 'Wrong Input! It should be a 4 digit number composed by numbers between 1 and 6!'
      guess_secret
    end
  end
end

# Creates a new computer player, role can be creator or guesser
class Computer
  attr_accessor :role

  def initialize
    choices = [1, 2, 3, 4, 5, 6]
    @possible_guesses = choices.repeated_permutation(4).to_a
  end

  def pick_secret
    secret = []
    4.times do
      secret << rand(1..6)
    end
    puts "I have now picked the secret code, you can start guessing when you're ready!"
    secret
  end

  def guess_secret(round)
    sleep 1
    secret = []
    if round.eql?(1)
      secret = [1, 1, 2, 2]
    else
      4.times do
        secret << rand(1..6)
      end
    end
    secret
  end
end

# Creates a new board
class Board
  def initialize
    puts 'o o o o'
  end
end

# Contains the game logic
class Game
  def initialize
    @winner = false
    @round = 1
  end

  def play
    create_players
    store_secret
    play_round until @winner || @round == 13
    if @winner
      puts "Good job #{@human.name}, you won the Game!"
    else
      puts 'Too bad, I won the Game!!!'
    end
  end

  def round_number
    @round
  end

  def play_round
    check_guess
    @round += 1
  end

  def create_players
    puts "Hello Human, what's your name?"
    @human = Human.new(gets.chomp)
    @computer = Computer.new
    choose_roles
    puts "Nice to meet you #{@human.name}! You will be the #{@human.role} and I will be the #{@computer.role}!"
  end

  def choose_roles
    puts 'Insert 0 if you want to be the creator or 1 if you want to be the guesser'
    role = gets.to_i
    if role.zero?
      @human.role = 'Creator'
      @computer.role = 'Guesser'
    elsif role.eql?(1)
      @human.role = 'Guesser'
      @computer.role = 'Creator'
    else
      puts 'Wrong Input! Insert 0 if you want to be the creator or 1 if you want to be the guesser'
    end
  end

  def store_secret
    @secret = if @human.role.eql?('Creator')
                @human.pick_secret
              else
                @computer.pick_secret
              end
  end

  def ask_guess
    @guess = if @human.role.eql?('Guesser')
               @human.guess_secret
             else
               @computer.guess_secret(@round)
             end
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
    if @human.role.eql?('Guesser')
      p right_position + right_color
    else
      p "#{right_position.length} - #{right_color.length}"
    end
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
end

Game.new.play
# Temporary code for tests
