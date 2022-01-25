# frozen_string_literal: true

# Creates a new human player, role can be creator or guesser
class Player
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
end

# Temporary code for tests
puts 'Insert human name'
player = Player.new(gets.chomp)
puts "Human name is #{player.name} and his role is #{player.role}"
computer = Computer.new
puts "Computer role is #{computer.role}"
