# Main game file!
require 'pry'

class Board #begin with only a 5x5 board as an option to test other functions

  def initialize 
    @horizontal = 5
    @vertical = 5
    @total_mines = 3
    @finished = :false #false, true, dead all symbols!
    @game_board = Array.new(@vertical) {Array(@horizontal.times.map{" "})}
    @display_board = Array.new(@vertical) {Array(@horizontal.times.map{"0"})}
    generate_mines
    return self.show_board
  end

  def show_board
    @vertical.times do |i| 
      print ("y#{@vertical-i} |").to_s.center(3)
      @horizontal.times {|j| print @display_board[@vertical-i-1][j].to_s.center(3)} 
      puts "\n" 
    end
    print "-".center(4)
    @horizontal.times {|j| print "-".to_s.center(3)} 
    puts "\n" 
    print "0".center(4)
    @horizontal.times {|j| print "x#{j+1}".to_s.center(3)} 
    puts "\n" 
    # uncomment below if you need to see the actual gameboard
    # @vertical.times do |i| 
    #   print (@vertical-i).to_s.center(3)
    #   @horizontal.times {|j| print @game_board[@vertical-i-1][j].to_s.center(3)} 
    #   puts "\n" 
    # end
    # print "0".center(3)
    # @horizontal.times {|j| print (j+1).to_s.center(3)} 
    # puts "\n" 
  end

  def question_cell(x,y)
    @display_board[y-1][x-1] = "?"
    self.show_board
  end

  def sweep_cell(x,y)
    case @finished
    when :true
      puts "You already won this game!"
    when :dead
      puts "Sorry, you're already dead. That sucks."
    else
      if @game_board[y-1][x-1] == "!"
        @display_board[y-1][x-1] = "!"
        end_game
      else
        display_num = 0
        if y-2 >= 0
          if x-2 >= 0
            @game_board[y-2][x-2] == "!" ? display_num += 1 : display_num
          end
          @game_board[y-2][x-1] == "!" ? display_num += 1 : display_num
          if not x == @horizontal
            @game_board[y-2][x] == "!" ? display_num += 1 : display_num
          end
        end
        if x-2 >= 0
          @game_board[y-1][x-2] == "!" ? display_num += 1 : display_num
        end
        @game_board[y-1][x-1] == "!"? display_num += 1 : display_num
        if not x == @horizontal
          @game_board[y-1][x] == "!" ? display_num += 1 : display_num
        end
        if not y == @vertical
          if x-2 != 0
            @game_board[y][x-2] == "!" ? display_num += 1 : display_num
          end
          @game_board[y][x-1] == "!"? display_num += 1 : display_num
          if not x == @horizontal
            @game_board[y][x] == "!" ? display_num += 1 : display_num
          end
        end
        display_num != 0 ? @display_board[y-1][x-1] = display_num : @display_board[y-1][x-1]  = "."
        @game_board[y-1][x-1]  = "c"
        self.show_board
        self.win_check
      end
    end
  end

  def win_check
    case @finished
    when :true
      puts "You already won this game!"
    when :dead
      puts "Sorry, you're already dead. That sucks."
    else
      cell_count = 0
      @vertical.times do |i| 
        @horizontal.times {|j| @game_board[i-1][j-1] == " " ? cell_count += 1 : cell_count }
      end
      if cell_count > 0
        puts "You have #{cell_count} more cells to sweep!"
      else
        puts "You won the game, congratulations!"
        @finished = :true
      end
    end
  end
  
  private
  
  def generate_mines #private!
    mines = 0
    while mines < @total_mines do
      samp_ver, samp_hor = (rand(1..@vertical)-1), (rand(1..@horizontal) - 1)
      if @game_board[samp_ver][samp_hor] != "!" 
        @game_board[samp_ver][samp_hor] = "!" 
        mines += 1
      end
    end
  end

  def end_game #private!
    @finished = :dead
    puts "I'm sorry but you've swept land with a mine on it.\nNow you are dead.\n\nGame over."
  end

end

game1 = Board.new
binding.pry