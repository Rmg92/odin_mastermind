# frozen_string_literal: true

# Creates a new player, role can be creator or guesser
class Player
  attr_accessor :name
  attr_reader :role

  def initialize(name)
    @name = name
    @role = 'guesser'
  end
end

player = Player.new(gets.chomp)
puts player.name, player.role
