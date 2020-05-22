def clear_screen
  system 'clear'
end

def empty_line
  puts ""
end

class Move
  attr_accessor :value

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def to_s
    @value
  end
end

class Rock < Move
  def initialize
    @value = "rock"
  end

  def rock_wins?(other_move)
    ((rock? && other_move.scissors?) ||
    (rock? && other_move.lizard?))
  end

  def rock_lost?(other_move)
    ((rock? && other_move.paper?) ||
    (rock? && other_move.spock?))
  end

  def >(other_move)
    rock_wins?(other_move)
  end

  def <(other_move)
    rock_lost?(other_move)
  end
end

class Paper < Move
  def initialize
    @value = "paper"
  end

  def paper_wins?(other_move)
    ((paper? && other_move.rock?) ||
    (paper? && other_move.spock?))
  end

  def paper_lost?(other_move)
    ((paper? && other_move.scissors?) ||
    (paper? && other_move.lizard?))
  end

  def >(other_move)
    paper_wins?(other_move)
  end

  def <(other_move)
    paper_lost?(other_move)
  end
end

class Scissors < Move
  def initialize
    @value = "scissors"
  end

  def scissors_wins?(other_move)
    ((scissors? && other_move.paper?) ||
    (scissors? && other_move.lizard?))
  end

  def scissors_lost?(other_move)
    ((scissors? && other_move.spock?) ||
    (scissors? && other_move.rock?))
  end

  def >(other_move)
    scissors_wins?(other_move)
  end

  def <(other_move)
    scissors_lost?(other_move)
  end
end

class Lizard < Move
  def initialize
    @value = "lizard"
  end

  def lizard_wins?(other_move)
    ((lizard? && other_move.spock?) ||
    (lizard? && other_move.paper?))
  end

  def lizard_lost?(other_move)
    ((lizard? && other_move.scissors?) ||
    (lizard? && other_move.rock?))
  end

  def >(other_move)
    lizard_wins?(other_move)
  end

  def <(other_move)
    lizard_lost?(other_move)
  end
end

class Spock < Move
  def initialize
    @value = "spock"
  end

  def spock_wins?(other_move)
    ((spock? && other_move.rock?) ||
    (spock? && other_move.scissors?))
  end

  def spock_lost?(other_move)
    ((spock? && other_move.paper?) ||
    (spock? && other_move.lizard?))
  end

  def >(other_move)
    spock_wins?(other_move)
  end

  def <(other_move)
    spock_lost?(other_move)
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    @score = Score.new
    @move_history = []
  end

  def add_to_move_history
    move_history << move
  end

  def show_move_history
    sleep 1
    puts "Here is a list of moves #{name} has made so far:"
    empty_line
    sleep 2

    move_history.each_with_index do |move, idx|
      puts "#{idx + 1}. #{move.value}"
    end
  end
end

class Human < Player
  def initialize
    super
    set_name
  end

  def set_name
    clear_screen
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp.capitalize
      break unless n.match?(/[^A-z]/) || n.empty?
      puts "Sorry, must enter a value that contains only letters."
      empty_line
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if RPSGame::MOVES.keys.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = RPSGame::MOVES[choice]
    add_to_move_history
  end
end

class Computer < Player
  attr_accessor :personality
end

class R2D2 < Computer
  def initialize
    super
    @name = "R2D2"
    @personality = { Rock.new => 1 }
  end

  def choose
    moves = []

    personality.map do |move, tendency|
      tendency.times { moves << move }
    end

    self.move = moves.sample
    add_to_move_history
  end
end

class Siri < Computer
  def initialize
    super
    @name = "Siri"
    @personality = { Rock.new => 1, Paper.new => 0, Scissors.new => 3,
                     Lizard.new => 2, Spock.new => 2 }
  end

  def choose
    moves = []

    personality.map do |move, tendency|
      tendency.times { moves << move }
    end

    self.move = moves.sample
    add_to_move_history
  end
end

class Jarvus < Computer
  def initialize
    super
    @name = "Jarvus"
    @personality = { Lizard.new => 1, Spock.new => 1 }
  end

  def choose
    moves = []

    personality.map do |move, tendency|
      tendency.times { moves << move }
    end

    self.move = moves.sample
    add_to_move_history
  end
end

class Score
  attr_accessor :points

  def initialize
    @points = 0
  end

  def update
    self.points += 1
  end

  def reset
    self.points = 0
  end
end

class RPSGame
  attr_accessor :human, :computer, :scoreboard

  MOVES = { "rock" => Rock.new, "paper" => Paper.new,
            "scissors" => Scissors.new, "lizard" => Lizard.new,
            "spock" => Spock.new }
  COMPUTERS = [R2D2.new, Siri.new, Jarvus.new]
  WINNING_POINTS = 3

  def initialize
    @human = Human.new
    @computer = COMPUTERS.sample
    @scoreboard = { human.name => human.score,
                    computer.name => computer.score }
  end

  def display_welcome_message
    clear_screen
    puts "Hi #{human.name}!"
    empty_line
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    empty_line
  end

  def display_goodbye_message
    empty_line
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!"
  end

  def display_moves
    empty_line
    puts "#{human.name} chose: #{human.move}"
    sleep 1
    puts "#{computer.name} chose: #{computer.move}"
  end

  def human_won?
    human.move > computer.move
  end

  def computer_won?
    human.move < computer.move
  end

  def player_won?
    human_won? || computer_won?
  end

  def tie?
    !human_won? && !computer_won?
  end

  def display_round_winner
    empty_line
    sleep 2
    if player_won?
      human_won? ? (winner = human) : (winner = computer)
      puts "#{winner.name} won this round!"
      winner.score.update
    elsif tie?
      puts "It's a tie!"
    end
  end

  def display_score
    sleep 1
    empty_line
    puts "The score is..."
    empty_line
    sleep 2
    puts "#{human.name}: #{human.score.points}"
    puts "#{computer.name}: #{computer.score.points}"
    empty_line
  end

  def grand_winner?
    human.score.points == WINNING_POINTS ||
      computer.score.points == WINNING_POINTS
  end

  def find_grand_winner
    return human.name if human.score.points == WINNING_POINTS
    return computer.name if computer.score.points == WINNING_POINTS
  end

  def reset_players_scores
    human.score.reset if grand_winner?
    computer.score.reset if grand_winner?
  end

  def display_grand_winner
    sleep 1
    puts "#{find_grand_winner} has won the game!" if grand_winner?
    empty_line
  end

  def display_move_history
    empty_line
    human.show_move_history
    empty_line
    computer.show_move_history
  end

  def show_move_history?
    answer = nil

    loop do
      puts "Would you like to see a history of the moves made so far? y or n"
      answer = gets.chomp
      break if ["y", "n"].include? answer.downcase
      puts "Sorry, must be y or n ."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def play_again?
    answer = nil

    loop do
      empty_line
      puts "Would you like to play again? y or n"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n ."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def players_choose_moves
    human.choose
    computer.choose
  end

  def display_results
    display_moves
    display_round_winner
    display_score
    display_grand_winner
  end

  def play
    display_welcome_message

    loop do
      players_choose_moves
      display_results
      display_move_history if show_move_history?
      reset_players_scores
      break unless play_again?
      clear_screen
    end

    display_goodbye_message
  end
end

RPSGame.new.play
