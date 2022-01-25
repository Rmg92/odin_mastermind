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
end

# Temporary code for tests
puts 'Insert human name'
human = Human.new(gets.chomp)
puts "Human name is #{human.name} and his role is #{human.role}"
computer = Computer.new
puts "Computer role is #{computer.role}"
