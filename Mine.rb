require_relative "Cell"

class Mine < Cell
  def initialize(coord)
    @coord = [coord[:x], coord[:y]]
    @display = :false
    @danger_lvl = :mine
    calc_presentation
  end
end