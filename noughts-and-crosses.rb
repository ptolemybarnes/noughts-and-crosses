class NoughtsAndCrosses

	def initialize(ai_mode=false)
		@start_time = Time.new
		@move_log = Array.new
		@turn = "O"
		@ai_mode = ai_mode
		lineWidth = 80

		@loc = {
		a_3: "1",
		b_3: "2",
		c_3: "3",
		a_2: "4",
		b_2: "5",
		c_2: "6",
		a_1: "7",
		b_1: "9",
		c_1: "9",
	}
		@moves_array = @loc.keys #makes a list of moves available for the AI.

	@win_conditions = [
		[:a_3, :b_3, :c_3],[:a_2, :b_2, :c_2],[:a_1, :b_1, :c_1], #rows
		[:a_1, :a_2, :a_3],[:b_1, :b_2, :b_3],[:c_1, :c_2, :c_3], #columns
		[:a_1, :b_2, :c_3],[:c_1, :b_2, :a_3]] #diagonals

	@board = Proc.new do
			puts( "___________________".center(lineWidth))
			puts( "|     |     |     |".center(lineWidth))
			puts( "|  #{@loc[:a_3]}  |  #{@loc[:b_3]}  |  #{@loc[:c_3]}  |".center(lineWidth))
			puts( "|_____|_____|_____|".center(lineWidth))
			puts( "|     |     |     |".center(lineWidth))
			puts( "|  #{@loc[:a_2]}  |  #{@loc[:b_2]}  |  #{@loc[:c_2]}  |".center(lineWidth))
			puts( "|_____|_____|_____|".center(lineWidth))
			puts( "|     |     |     |".center(lineWidth))
			puts( "|  #{@loc[:a_1]}  |  #{@loc[:b_1]}  |  #{@loc[:c_1]}  |".center(lineWidth))
			puts( "|_____|_____|_____|".center(lineWidth))
		end
		moveprompt
	end

	def set_board
		puts "Let the game begin!!!" if @move_log.length == 0
		@board.call
	end

	def moveprompt
		set_board
		puts "\nIt is #{@turn}'s turn.\n Please state your move:"

		if @ai_mode && @turn == "X"
			move = get_ai_move
		else 
			move = gets.chomp.intern # gets user's move.
		end
		
		if @loc.has_key?(move) && !@move_log.include?(move) # ensures move requested by user is valid and has not been made before.
			self.move = move
		elsif move == :exit
			@turn = "no winner :-("
			end_game
		else
			puts "Not a valid move."
			moveprompt
		end
	end

	def get_ai_move #for now, AI will return a random (valid) move.
		available_moves = @moves_array - @move_log
		available_moves.shuffle[0]
	end

	def move=(move)
		@move_log.push move
		puts "\nAfter #{@move_log.length} moves..."
		@loc[move] = @turn
			if win?
				set_board
				end_game
			else
				turn_switch
				moveprompt
			end
	end

	def win?
		win = false
		@win_conditions.each do |dimension_array|
			win = true if is_dimension_a_winner?(dimension_array)
		end
		win
	end

	def is_dimension_a_winner?(dimension_array)
		dimension_array.each do |coordinate|
			return false unless @turn == @loc[coordinate]
		end
		true
	end

	def turn_switch
		if @turn == "X"
			@turn = "O"
		else
			@turn = "X"
		end
	end

	def end_game
		puts "\nGAME OVER!\n The game lasted #{(Time.new - @start_time).to_i} seconds and the winner was #{@turn}'s"
	end

end

def game_starter
	puts "Options:"
	puts " Enter 1 for two-player mode."
	puts " Enter 2 to play against the AI."
	puts " Enter 'exit' to quit."
	input = gets.chomp
	if input == "1"
		NoughtsAndCrosses.new
	elsif input == "2"
		NoughtsAndCrosses.new(true)
	elsif input == "exit"
	else
		puts "Invalid option.\n"
		game_starter
	end
end

game_starter