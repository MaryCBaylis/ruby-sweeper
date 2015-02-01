require_relative "Game"

cake_level = {:horizontal => 5, :vertical => 5, :total_mines => 2}
easy_level = {:horizontal => 10, :vertical => 10, :total_mines => 4}
medium_level = {:horizontal => 20, :vertical => 20, :total_mines => 10}
hard_level = {:horizontal => 50, :vertical => 30, :total_mines => 50}
nightmare_level = {:horizontal => 50, :vertical => 50, :total_mines => 100}
hell_level = {:horizontal => 50, :vertical => 50, :total_mines => 150}
custom_level = {:horizontal => nil, :vertical => nil, :total_mines => nil}
valid_input = false
game_is_active = true
custom_request = ["7", "custom"]

get_difficulty = {
	"1" => cake_level,
	"cake" => cake_level,
	"2" => easy_level,
	"easy" => easy_level,
	"3" => medium_level,
	"medium" => medium_level,
	"4" => hard_level,
	"hard" => hard_level,
	"5" => nightmare_level,
	"nightmare" => nightmare_level,
	"6" => hell_level,
	"hell" => hell_level,
	"7" => custom_level,
	"custom" => custom_level
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

custom_mode_string = {
	:horizontal => "rows",
	:vertical => "columns",
	:total_mines => "mines"
}

current_mode = :sweep

start_io = proc do
	puts "Welcome to RubySweeper!  Select your mode:"
	puts
	puts "1: Cake"
	puts "2: Easy"
	puts "3: Medium"
	puts "4: Hard"
	puts "5: Nightmare"
	puts "6: Hell"
	puts "7: Custom"
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



create_custom_game = proc do |input|
	custom_mode_string.each do |key, requested_info|
		valid_input = false
		while !valid_input
			puts "Enter the number of #{requested_info}"
			input = gets.chomp.to_i
			if input > 0
				valid_input = true
				custom_level[key] = input
			end
		end
	end
end

@interpret_input = proc do |input|
	coordinates = input.split(",")
	if get_difficulty.has_key?(input)
		create_custom_game.call if custom_request.include?(input)
		@game = Game.new(get_difficulty[input])
		valid_input = true
	elsif get_mode.has_key?(input)
		current_mode = get_mode[input]
		valid_input = true
	elsif extra_actions.has_key?(input)
		extra_option.call(input)
	elsif coordinates[0].to_i.is_a?(Integer) && coordinates[1].to_i.is_a?(Integer) && coordinates.size == 2
		begin
			if current_mode == :sweep
				@game.sweep(coordinates[0].to_i, coordinates[1].to_i)
			elsif current_mode == :flag
		 		@game.flag(coordinates[0].to_i, coordinates[1].to_i)
			elsif current_mode == :question
		 		@game.question(coordinates[0].to_i, coordinates[1].to_i)
		 	end
		rescue 
			puts "That doesn't seem to be a valid move.  Try again!"
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