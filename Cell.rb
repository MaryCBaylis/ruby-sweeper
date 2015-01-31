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
        when :question then '?'
        when :flag then "⚑"
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

  def question
    @display = :question
    calc_presentation
  end

  def flag
    @display = :flag
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