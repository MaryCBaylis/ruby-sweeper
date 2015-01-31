require_relative "Cell"
require_relative "Mine"

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

#10,5 overswept 5,10?
#5,1 overswept 1,5 The sweep is in the correct spot, but the oversweep is not<- where's the switch in coordinates?
#2,7 swept 2,7, but overswept 7,2
#bug seems to happen when inverse coord is not in the same overswept area as coord.  It appears oversweep is being called on the inverse each time, but changing the order of coordinates severely breaks oversweep
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