# Main game file!
require 'pry'

# handles all incoming user input and output.
#
class Game
  def initialize
    @make_board = Hash.new {
    horizontal: 5,
    vertical: 5,
    total_mines: 3
    }
    @game_board = Board.new(@make_board)
    show
  end

  def show
    @game_board.show_board
  end
end

class Board #begin with only a 5x5 board as an option to test other functions

  def initialize(board_spec)
    @horizontal = board_spec[:horizontal]
    @vertical = board_spec[:vertical]
    @total_mines = board_spec[:total_mines]
    @finished = :false #false, true, dead all symbols!
    @game_board = Array.new(@vertical) {Array(@horizontal.times.map{" "})}
    # @display_board = Array.new(@vertical) {Array(@horizontal.times.map{"0"})}
    generate_mines
  end

  def show_board
    @vertical.times do |i|
      print "y#{@vertical - i} |".center(3)
      @horizontal.times { |j| print @display_board[@vertical - i - 1][j].to_s.center(3) }
      puts "\n"
    end
    print '-'.center(4)
    @horizontal.times { print '-'.to_s.center(3) }
    puts "\n"
    print '0'.center(4)
    @horizontal.times { |j| print "x#{j + 1}".center(3) }
    puts "\n"
  end

  def question_cell(x, y)
    @display_board[y - 1][x - 1] = '?'
    show_board
  end

  def sweep_cell(x, y)
    case @finished
    when :true
      puts 'You already won this game!'
    when :dead
      puts "Sorry, you're already dead. That sucks."
    else
      if @game_board[y - 1][x - 1] == '!'
        @display_board[y - 1][x - 1] = '!'
        end_game
      else
        display_num = 0
        if y - 2 >= 0
          if x - 2 >= 0
            @game_board[y - 2][x - 2] == '!' ? display_num += 1 : display_num
          end
          @game_board[y - 2][x - 1] == '!' ? display_num += 1 : display_num
          if x == !@horizontal
            @game_board[y - 2][x] == '!' ? display_num += 1 : display_num
          end
        end
        if x - 2 >= 0
          @game_board[y - 1][x - 2] == '!' ? display_num += 1 : display_num
        end
        @game_board[y - 1][x - 1] == '!' ? display_num += 1 : display_num
        if x == !@horizontal
          @game_board[y - 1][x] == '!' ? display_num += 1 : display_num
        end
        if y == !@vertical
          if x - 2 != 0
            @game_board[y][x - 2] == '!' ? display_num += 1 : display_num
          end
          @game_board[y][x - 1] == '!' ? display_num += 1 : display_num
          if x == !@horizontal
            @game_board[y][x] == '!' ? display_num += 1 : display_num
          end
        end
        display_num != 0 ? @display_board[y - 1][x - 1] = display_num : @display_board[y - 1][x - 1]  = '.'
        @game_board[y - 1][x - 1]  = 'c'
        show_board
        win_check
      end
    end
  end

  def win_check
    case @finished
    when :true
      puts 'You already won this game!'
    when :dead
      puts "Sorry, you're already dead. That sucks."
    else
      c = 0
      @vertical.times do |i|
        @horizontal.times { |j| @game_board[i - 1][j - 1] == ' ' ? c += 1 : c }
      end
      if c > 0
        puts "You have #{c} more cells to sweep!"
      else
        puts 'You won the game, congratulations!'
        @finished = :true
      end
    end
  end

  private

  def generate_mines
    mines = 0
    while mines < @total_mines
      samp_ver, samp_hor = (rand(1..@vertical) - 1), (rand(1..@horizontal) - 1)
      if @game_board[samp_ver][samp_hor] != '!'
        @game_board[samp_ver][samp_hor] = '!'
        mines += 1
      end
    end
  end

  def end_game
    @finished = :dead
    puts "I'm sorry but you've swept land with a mine on it.\nNow you are dead.
    \n\nGame over."
  end
end

# binding.pry
