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
  def print_board(guess, right_position, right_color)
    puts "Guess: #{guess[0]} #{guess[1]} #{guess[2]} #{guess[3]} Hints: #{right_position[0]}#{right_position[1]}#{right_position[2]}#{right_position[3]} #{right_color[0]}#{right_color[1]}#{right_color[2]}#{right_color[3]}"
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

  def declare_winner
    if @winner.eql?(false)
      if @human.role.eql?('Creator')
        puts "Code not Found! #{@human.name} is the Winner!"
      else
        puts "Code not Found! #{@computer.name} is the Winner!"
      end
    else
      puts "Code Found! #{@winner.name} is the Winner!"
    end
  end

  def play_round
    check_guess
    @round += 1
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
    @board.print_board(@guess, right_position, right_color)
    @computer.delete_possible_guesses(right_position.length, right_color.length) if @computer.role.eql?('Guesser')
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
                puts "#{@computer.name} has now picked the secret code, you can start guessing when you're ready!"
                @computer.pick_secret
              end
  end
end

game = Game.new
game.play
