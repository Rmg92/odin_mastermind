# frozen_string_literal: true

require 'pry-byebug'

# Creates a new human player, role can be creator or guesser
class Human
  attr_accessor :name
  attr_reader :role

  def initialize(name)
    @name = name
    @role = 'Guesser'
  end

  def guess_secret
    gets.split('').map(&:to_i).delete_if(&:zero?)
  end
end

# Creates a new computer player, role can be creator or guesser
class Computer
  attr_reader :role

  def initialize
    @role = 'Creator'
  end

  def pick_secret
    secret = []
    4.times do
      secret << rand(1..6)
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
    create_players
    store_secret
    p ask_guess
  end

  def create_players
    puts "Hello Human, what's your name?"
    @human = Human.new(gets.chomp)
    @computer = Computer.new
    puts "Nice to meet you #{@human.name}! You will be the #{@human.role} and I will be the #{@computer.role}"
  end

  def store_secret
    puts "I have now picked the secret code, you can start guessing when you're ready!"
    @secret = @computer.pick_secret
  end

  def ask_guess
    puts 'Input your guess! It should be a 4 digit number composed by numbers between 1 and 6!'
    guess = @human.guess_secret
    if guess.all? { |number| number.between?(1, 6) } && guess.length == 4
      guess
    else
      puts 'Wrong Input! It should be a 4 digit number composed by numbers between 1 and 6!'
      ask_guess
    end
  end
end

Game.new
# Temporary code for tests
