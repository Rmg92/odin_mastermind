# frozen_string_literal: true

# Creates a new human player, role can be creator or guesser
class Human
  attr_accessor :name, :role

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
  attr_accessor :role

  def initialize
    choices = [1, 2, 3, 4, 5, 6]
    @possible_guesses = choices.repeated_permutation(4).to_a
    @last_guess = []
    @name = 'Jarvas'
  end

  def pick_secret
    secret = []
    4.times do
      secret << rand(1..6)
    end
    puts "I have now picked the secret code, you can start guessing when you're ready!"
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
    p secret
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
    play_round while @winner.eql?(false) && @round < 13
    # Change code so the correct winner is annouced
    declare_winner
  end

  def declare_winner
    if @winner.eql?(false)
      if @human.role.eql?('Creator')
        puts "#{@human.name} is the Winner!"
      else
        puts "#{@computer.name} is the Winner!"
      end
    else
      puts "#{@winner.name} is the Winner!"
    end
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
    puts "Nice to meet you #{@human.name}, you will be the #{@human.role}!\n" \
         "Your opponent will be #{@computer.name} as the #{@computer.role}!"
  end

  def choose_roles
    puts 'Insert 0 if you want to be the Creator or 1 if you want to be the Guesser'
    role = gets.to_i
    if role.zero?
      @human.role = 'Creator'
      @computer.role = 'Guesser'
    elsif role.eql?(1)
      @human.role = 'Guesser'
      @computer.role = 'Creator'
    else
      puts 'Wrong Input!'
      choose_roles
    end
  end

  def ask_guess
    @guess = if @human.role.eql?('Guesser')
               @human.guess_secret
             else
               @computer.guess_secret
             end
  end

  def check_guess
    ask_guess
    if @secret.eql?(@guess)
      @winner = if @human.role.eql?('Guesser')
                  @human
                else
                  @computer
                end
    else
      @hinted = []
      give_feedback
    end
  end

  def give_feedback
    if @human.role.eql?('Guesser')
      p right_position + right_color
    else
      @computer.delete_possible_guesses(right_position.length, right_color.length)
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

  private

  def store_secret
    @secret = if @human.role.eql?('Creator')
                @human.pick_secret
              else
                puts 'I will now pick the secret code.'
                @computer.pick_secret
              end
  end
end

Game.new.play
# Temporary code for tests
