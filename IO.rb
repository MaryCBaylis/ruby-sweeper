require_relative "Game"

class IO
	def initialize
		easy_level = 10
		medium_level = 20
		hard_level = 30

		@get_difficulty = {
		"1" => easy_level,
		"e" => easy_level,
		"easy" => easy_level,
		"2" => medium_level,
		"m" => medium_level,
		"medium" => medium_level,
		"3" => hard_level,
		"h" => hard_level,
		"hard" => hard_level,
		}

		@get_mode = {
			"s" => :sweep,
			"sweep" => :sweep,
			"f" => :flag,
			"flag" => :flag,
			"q" => :question,
			"question" => :question
		}

		@extra_actions = {
			"exit" => :exit,
			"quit" => :quit,
			"help" => :help,
			"new" => :new_game,
			"new game" => :new_game


		}
	end

	def start_interaction
			#We can probably encapsulate this  and the next interaction in procs.  Cleaner!  Assuming we can get them to work, anyways.  Good proc practice!
			puts "Welcome to RubySweeper!  Select your mode:"

			puts "1: (E)asy"
			puts "2: (M)edium"
			puts "3: (H)ard"
			puts
			input = gets.chomp.downcase
			return input
	end

		

	def next_step_interaction(mode)
		puts "Enter "
	end
end

# puts "Welcome to RubySweeper!  Select your mode:"
# puts 
# puts "1: (E)asy"
# puts "2: (M)edium"
# puts "3: (H)ard"
# # puts "4: (I)mpossible"
# # puts "5: (C)ustom"
# puts 

# input = gets.chomp





# num_of_rows = mode_hash[input]

# easy_level = 10
# medium_level = 20
# hard_level = 30

# get_difficulty = {
# 	"1" => easy_level,
# 	"e" => easy_level,
# 	"easy" => easy_level,
# 	"2" => medium_level,
# 	"m" => medium_level,
# 	"medium" => medium_level,
# 	"3" => hard_level,
# 	"h" => hard_level,
# 	"hard" => hard_level,
# }

# game = Game.new(num_of_rows, num_of_rows)


