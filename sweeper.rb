# Main game file!
require 'pry'

# handles all incoming user input and output.
#
class Game
  attr_reader :game_status, :game_board

  def initialize(x,y)
    @make_board = { horizontal: x, vertical: y, total_mines: (x * y / 9) }
    @game_board = Board.new(@make_board)
    @game_status = :playing # also :loss and :victory
    show
  end

  def show
    @game_board.show_board
  end

  def win_check

  end

  def sweep(x,y)
    @game_board.get_obj_by_coord(x,y).sweep
    show
  end

  def lose
    @game_board.lose_game
    show
  end
end

# This will fill the board array; each is auto-populated.
#
class Cell
  def initialize(data)
    @display = :false
    @coord = [data[:x],data[:y]]
    @danger_lvl = data[:danger]
    calc_presentation
  end

  def calc_presentation
    @display_val = 
      case @display
      when :true 
        case @danger_lvl
        when 0 then "."
        when :mine then "X"
        else @danger_lvl
        end
      when :question then "?"
      when :false then "0"
      end
  end

  def present
    print @display_val.to_s.center(3)
  end

  def sweep
    @display = :true
    calc_presentation
  end

  def mark
    @display = :question
    calc_presentation
  end

  def oversweep
    @display = :true
    calc_presentation
  end
end

# This is the bomb factory!
#
class Mine < Cell
  def initialize(coord)
    @coord = [coord[:x],coord[:y]]
    @display = :false
    @danger_lvl = :mine
    calc_presentation
  end
end

# begin with only a 5x5 board as an option to test other functions
#
class Board
  attr_reader :total_mines, :horizontal, :vertical

  def initialize(board_spec)
    @horizontal = board_spec[:horizontal]
    @vertical = board_spec[:vertical]
    @total_mines = board_spec[:total_mines]
    @board = Array.new(@vertical) {Array.new(@horizontal, nil)}
    generate_mines
    generate_cells
  end

  def generate_mines
    mines = []
    while mines.size < @total_mines
      ver, hor = (rand(1..@vertical) - 1), (rand(1..@horizontal) - 1)
      !mines.include?([ver,hor]) ? mines << [ver,hor] : mines
    end
    mines.each { |i| @board[i[0]][i[1]] = Mine.new({ :x => i[1], :y => i[0]}) }
  end

  def generate_cells
    @board.size.times do |i|
      @board[i].size.times do |j| 
        @board[i-1][j-1] ||= Cell.new( {
          :x => j-1,
          :y => i-1,
          :danger => find_danger(j, i)
          } )
      end
    end
  end

  def find_danger(x, y)
    danger = 0
    [(y - 1), y, (y + 1)].each do |i|
      [(x - 1), x, (x + 1)].each do |j|
        if in_bounds(j,i)
          danger += 1 if get_obj_by_coord(j,i).class == Mine
        end
      end
    end
    danger
  end

  def in_bounds(x,y)
    x >= 0 && x < @horizontal && y >= 0 && y < @vertical
  end

  def show_board
    @vertical.times do |i|
      print "y#{@vertical - i} |".center(3)
      @horizontal.times do |j| 
        print @board[@vertical - i - 1][j].present
      end
      puts "\n"
    end
    print '-'.center(4)
    @horizontal.times { print '-'.to_s.center(3) }
    puts "\n"
    print '0'.center(4)
    @horizontal.times { |j| print "x#{j + 1}".center(3) }
    puts "\n"
  end

  def get_obj_by_coord(x,y)
    return @board[y-1][x-1]
  end

  def lose_game
    @vertical.times do |i|
      @horizontal.times { |j| @board[i][j].sweep }
    end
    @game_status = :loss
  end
  
  def count_cells
    result[:total] = @horizontal * @vertical
    result[:remaining] = 0
    @vertical.times do |i|
      @horizontal.times do |j| 
        @board[i][j].class == Mine ? result[:remaining] += 1 : result[:remaining] 
      end
    end
  end
  # def sweep_cell(x, y)
  #   case @finished
  #   when :true
  #     puts 'You already won this game!'
  #   when :dead
  #     puts "Sorry, you're already dead. That sucks."
  #   else
  #     if @game_board[y - 1][x - 1] == '!'
  #       @display_board[y - 1][x - 1] = '!'
  #       end_game
  #     else
  #       display_num = 0
  #       if y - 2 >= 0
  #         if x - 2 >= 0
  #           @game_board[y - 2][x - 2] == '!' ? display_num += 1 : display_num
  #         end
  #         @game_board[y - 2][x - 1] == '!' ? display_num += 1 : display_num
  #         if x == !@horizontal
  #           @game_board[y - 2][x] == '!' ? display_num += 1 : display_num
  #         end
  #       end
  #       if x - 2 >= 0
  #         @game_board[y - 1][x - 2] == '!' ? display_num += 1 : display_num
  #       end
  #       @game_board[y - 1][x - 1] == '!' ? display_num += 1 : display_num
  #       if x == !@horizontal
  #         @game_board[y - 1][x] == '!' ? display_num += 1 : display_num
  #       end
  #       if y == !@vertical
  #         if x - 2 != 0
  #           @game_board[y][x - 2] == '!' ? display_num += 1 : display_num
  #         end
  #         @game_board[y][x - 1] == '!' ? display_num += 1 : display_num
  #         if x == !@horizontal
  #           @game_board[y][x] == '!' ? display_num += 1 : display_num
  #         end
  #       end
  #       display_num != 0 ? @display_board[y - 1][x - 1] = display_num : @display_board[y - 1][x - 1]  = '.'
  #       @game_board[y - 1][x - 1]  = 'c'
  #       show_board
  #       win_check
  #     end
  #   end
  # end

  # def win_check
  #   case @finished
  #   when :true
  #     puts 'You already won this game!'
  #   when :dead
  #     puts "Sorry, you're already dead. That sucks."
  #   else
  #     c = 0
  #     @vertical.times do |i|
  #       @horizontal.times { |j| @game_board[i - 1][j - 1] == ' ' ? c += 1 : c }
  #     end
  #     if c > 0
  #       puts "You have #{c} more cells to sweep!"
  #     else
  #       puts 'You won the game, congratulations!'
  #       @finished = :true
  #     end
  #   end
  # end

  # def end_game
  #   @finished = :dead
  #   puts "I'm sorry but you've swept land with a mine on it.\nNow you are dead.
  #   \n\nGame over."
  # end
end

game1 = Game.new(10,10)
# binding.pry
puts
game1.lose