# Main game file!
require 'pry'

# handles all incoming user input and output.
#
class Game
  attr_reader :game_status

  def initialize(x, y)
    @make_board = { horizontal: x, vertical: y, total_mines: 6 } # (x * y / 8) }
    @game_board = Board.new(@make_board)
    @game_status = :continue
    show
  end

  def show
    @game_board.show_board
  end

  def win_check
    check = @game_board.count_cells
    @game_status = :victory if check[:remaining] == 0 && game_status != :loss
    status_check(check[:remaining])
  end

  def status_check(remaining)
    case @game_status
    when :victory
      puts 'Congratulations you won this game!'
      return :stop
    when :loss
      puts 'This game was LOST sucka'
      return :stop
    else
      puts "You have #{remaining} cells to go."
      return :continue
    end
  end

  def sweep(x, y)
    if @game_status == :continue
      if @game_board.get_obj_by_coord(x - 1, y - 1).danger_lvl == :mine
        lose
      else
        if @game_board.get_obj_by_coord(x - 1, y - 1).danger_lvl == 0
          @game_board.oversweep(x - 1, y - 1)
        end
        @game_board.get_obj_by_coord(x - 1, y - 1).sweep
        show
      end
    end
    win_check
  end

  def lose
    @game_status = :loss
    @game_board.reveal_board
    show
  end
end

# This will fill the board array; each is auto-populated.
#
class Cell
  attr_reader :danger_lvl, :display, :swept
  def initialize(data)
    @display = :false
    @swept = :false
    @coord = [data[:x], data[:y]]
    @danger_lvl = data[:danger]
    calc_presentation
  end

  def calc_presentation
    @display_val =
      case @display
      when :true
        case @danger_lvl
        when 0 then ' '
        when :mine then 'X'
        else @danger_lvl
        end
      # when :question then '?'
      when :false then '-'
      end
  end

  def present
    print @display_val.to_s.center(3)
  end

  def sweep
    @display = :true
    @swept = :true
    calc_presentation
    @danger_lvl
  end

  def mark
    @display = :question
    calc_presentation
  end
end

# This is the bomb factory!
#
class Mine < Cell
  def initialize(coord)
    @coord = [coord[:x], coord[:y]]
    @display = :false
    @danger_lvl = :mine
    calc_presentation
  end
end

# begin with only a 5x5 board as an option to test other functions
#
class Board
  attr_reader :total_mines, :horizontal, :vertical, :board
  def initialize(board_spec)
    @horizontal = board_spec[:horizontal]
    @vertical = board_spec[:vertical]
    @total_mines = board_spec[:total_mines]
    @board = Array.new(@vertical) { Array.new(@horizontal, nil) }
    generate_mines
    generate_cells
  end

  def show_board
    @vertical.times do |i|
      print "y#{@vertical - i} |".center(5)
      @horizontal.times do |j|
        print @board[@vertical - i - 1][j].present
      end
      puts "\n"
    end
    print '-'.center(5)
    @horizontal.times { print '---'.to_s.center(3) }
    puts "\n"
    print '0'.center(5)
    @horizontal.times { |j| print "x#{j + 1}".center(3) }
    puts "\n"
  end

  def oversweep(x, y)
    [(y - 1), y, (y + 1)].each do |i|
      [(x - 1), x, (x + 1)].each do |j|
        if [x, y] != [j, i]
          if in_bounds(j, i)
            if @board[j][i].danger_lvl == 0 && @board[j][i].swept == :false
              @board[j][i].sweep
              oversweep(j, i)
            else
              @board[j][i].sweep
            end
          end # bounds
        end
      end
    end
  end

  def get_obj_by_coord(x, y)
    @board[y][x]
  end

  def reveal_board
    @vertical.times do |i|
      @horizontal.times { |j| @board[i][j].sweep }
    end
  end

  def count_cells
    result = { total: @horizontal * @vertical }
    result[:remaining] = 0
    @vertical.times do |i|
      @horizontal.times do |j|
        if @board[i - 1][j - 1].class != Mine && @board[i - 1][j - 1].display == :false
          result[:remaining] += 1
        end
      end
    end
    result
  end

  private

  def generate_mines
    gen_mine_coord.each do |i|
      @board[i[0]][i[1]] = Mine.new(x: i[1], y: i[0])
    end
  end

  def gen_mine_coord
    mines = []
    while mines.size < @total_mines
      ver, hor = (rand(1..@vertical) - 1), (rand(1..@horizontal) - 1)
      !mines.include?([ver, hor]) ? mines << [ver, hor] : mines
    end
    mines
  end

  def generate_cells
    @board.size.times do |i|
      @board[i].size.times do |j|
        @board[i][j] ||= Cell.new(x: j, y: i, danger: find_danger(j, i))
      end
    end
  end

  def find_danger(x, y)
    danger = 0
    [(y - 1), y, (y + 1)].each do |i|
      [(x - 1), x, (x + 1)].each do |j|
        danger += 1 if in_bounds(j, i) && get_obj_by_coord(j, i).class == Mine
      end
    end
    danger
  end

  def in_bounds(x, y)
    x >= 0 && x < @horizontal && y >= 0 && y < @vertical
  end
end

g = Game.new(30, 30)
puts
# print $help
# game1.lose
# binding.pry
