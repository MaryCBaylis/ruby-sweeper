require_relative "Game"

easy_level = 10
medium_level = 20
hard_level = 30
valid_input = false
game_is_active = true


get_difficulty = {
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

get_mode = {
	"s" => :sweep,
	"sweep" => :sweep,
	"f" => :flag,
	"flag" => :flag,
	"q" => :question,
	"question" => :question
}

extra_actions = {
	"exit" => :exit,
	"e" => :exit,
	"x" => :exit,
	"q" => :quit,
	"quit" => :quit,
	"help" => :help,
	"new" => :new_game,
	"new game" => :new_game
}

mode_string = {
	:sweep => ["sweep", "(f)lag or (q)uestion"],
	:flag => ["flag", "(s)weep or (q)uestion"],
	:question => ["question", "(s)weep or (f)lag"]
}

current_mode = :sweep

start_io = proc do
	puts "Welcome to RubySweeper!  Select your mode:"
	puts
	puts "1: (E)asy"
	puts "2: (M)edium"
	puts "3: (H)ard"
	puts
	input = gets.chomp.downcase
end

continue_io = proc do
	puts "Enter help at any time for more information."
	puts
	puts "Enter your coordinates in x,y format to #{mode_string[current_mode][0]} a cell, or enter #{mode_string[current_mode][1]} to change your mode."

	input = gets.chomp.downcase
end

#update this later
extra_option = proc do |input|
	if extra_actions[input] == :exit
		puts "Are you sure you want to exit? Y/N"
		input = gets.chomp.downcase
		if input == "y" || input == "yes"
			exit
		end
	elsif extra_actions[input] == :quit
		puts "Are you sure you want to quit? Y/N?"
		input = gets.chomp.downcase
		if input == "y" || input == "yes"
			@game.lose
		end
	elsif extra_actions[input] == :help
		puts "You can perform the following:"
		puts
		puts "help     - displays help file"
		puts "exit     - exits the game"
		puts "new      - quits the current game and creates a new game"
		puts "quit     - quits the current game"
		puts "x,y      - the coordinates you would like to act on"
		puts "sweep    - change to sweep mode, unveils the cell at the coordinates entered"
		puts "flag     - change to flag mode, flags the cell as a mine at the coordinates entered"
		puts "question - change to question mode, marks the cell at the coordinates entered with a question mark"
	elsif extra_actions[input] == :new_game
		puts "Are you sure you want to quit this game and start a new one? Y/N?"
		input = gets.chomp.downcase
		if input == "y" || input == "yes"
			puts "Starting a new game..."
			@start_game.call
		end
	end

end

@start_game = proc do |input|
	while !get_difficulty.has_key?(input)
		input = start_io.call
		if extra_actions.has_key?(input)
			@interpret_input.call(input)
		end
	end
	@interpret_input.call(input)
end

@interpret_input = proc do |input|
	coordinates = input.split(",")
	if get_difficulty.has_key?(input)
		@row_size = get_difficulty[input]
		@game = Game.new(@row_size, @row_size)
		valid_input = true
	elsif get_mode.has_key?(input)
		current_mode = get_mode[input]
		valid_input = true
	elsif extra_actions.has_key?(input)
		extra_option.call(input)
	elsif coordinates[0].to_i.is_a?(Integer) && coordinates[1].to_i.is_a?(Integer) && coordinates.size == 2
		if current_mode == :sweep
			@game.sweep(coordinates[0].to_i, coordinates[1].to_i)
			#We need to implement flag and question
		# elsif current_mode == :flag
		# 	game.flag(coordinates[0], coordinates[1])
		# elsif current_mode == :question
		# 	game.question(coordinates[0], coordinates[1])
		end
	else
		puts "Sorry, I don't understand what you just entered.  Please try again."
	end
end

#Game starts here
@start_game.call

while game_is_active
	@game.show
	input = continue_io.call
	@interpret_input.call(input)
	game_is_active = @game.game_status == :continue
end

# class IO
# 	def initialize
# 		easy_level = 10
# 		medium_level = 20
# 		hard_level = 30

# 		@get_difficulty = {
# 		"1" => easy_level,
# 		"e" => easy_level,
# 		"easy" => easy_level,
# 		"2" => medium_level,
# 		"m" => medium_level,
# 		"medium" => medium_level,
# 		"3" => hard_level,
# 		"h" => hard_level,
# 		"hard" => hard_level,
# 		}

# 		@get_mode = {
# 			"s" => :sweep,
# 			"sweep" => :sweep,
# 			"f" => :flag,
# 			"flag" => :flag,
# 			"q" => :question,
# 			"question" => :question
# 		}

# 		@extra_actions = {
# 			"exit" => :exit,
# 			"quit" => :quit,
# 			"help" => :help,
# 			"new" => :new_game,
# 			"new game" => :new_game
# 		}

# 		mode_string = {
# 			:sweep => ["sweep", "(f)lag or (q)uestion"],
# 			:flag => ["flag", "(s)weep or (q)uestion"],
# 			:question => ["question", "(s)weep or (f)lag"]
# 		}

# 		@start_io = proc do |input|
# 			puts "Welcome to RubySweeper!  Select your mode:"

# 			puts "1: (E)asy"
# 			puts "2: (M)edium"
# 			puts "3: (H)ard"
# 			puts
# 			input = gets.chomp.downcase
# 		end

# 		@continue_io = proc do |input|
# 				puts "Enter your coordinates in x,y format to #{@mode_string[@get_mode[[0]]} a cell, or enter #{@mode_string[@get_mode[[1]]} to change your mode."
# 				input = gets.chomp.downcase
# 		end


		
# 	end

# 	def start_interaction
# 			#We can probably encapsulate this  and the next interaction in procs.  Cleaner!  Assuming we can get them to work, anyways.  Good proc practice!
# 			puts "Welcome to RubySweeper!  Select your mode:"

# 			puts "1: (E)asy"
# 			puts "2: (M)edium"
# 			puts "3: (H)ard"
# 			puts
# 			input = gets.chomp.downcase
# 			return input
# 	end



		

# 	def next_step_interaction(mode)
# 		puts "Enter "
# 	end
# end

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


