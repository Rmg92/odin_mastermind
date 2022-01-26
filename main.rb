# frozen_string_literal: true

# Creates a new human player, role can be creator or guesser
class Human
  attr_accessor :name
  attr_reader :role

  def initialize(name)
    @name = name
    @role = 'Guesser'
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
    puts "Let's Play"
  end
end

# Temporary code for tests
puts 'Insert human name'
human = Human.new(gets.chomp)
puts "Human name is #{human.name} and his role is #{human.role}"
computer = Computer.new
puts "Computer role is #{computer.role}"
board = Board.new
game = Game.new
board
game
puts computer.pick_secret
