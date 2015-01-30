require_relative "Mine"
require_relative "Board"
require_relative "Cell"

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

# g = Game.new(30, 30)
# puts