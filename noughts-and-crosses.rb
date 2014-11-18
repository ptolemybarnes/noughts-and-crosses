class NoughtsAndCrosses

	def initialize(ai_mode=false)
		@start_time = Time.new
		@move_log = Array.new
		@turn = "O"
		@ai_mode = ai_mode
		lineWidth = 80

		@loc = {
		1 => "1",
		2 => "2",
		3 => "3",
		4 => "4",
		5 => "5",
		6 => "6",
		7 => "7",
		8 => "8",
		9 => "9",
	}
		@moves_array = @loc.keys #makes a list of moves available for the AI.

	@win_conditions = [
		[1, 2, 3],[4, 5, 6],[7, 8, 9], #rows
		[7, 4, 1],[8, 5, 2],[9, 6, 3], #columns
		[7, 5, 3],[9, 5, 1]] #diagonals

	@board = Proc.new do
			puts( "___________________".center(lineWidth))
			puts( "|     |     |     |".center(lineWidth))
			puts( "|  #{@loc[1]}  |  #{@loc[2]}  |  #{@loc[3]}  |".center(lineWidth))
			puts( "|_____|_____|_____|".center(lineWidth))
			puts( "|     |     |     |".center(lineWidth))
			puts( "|  #{@loc[4]}  |  #{@loc[5]}  |  #{@loc[6]}  |".center(lineWidth))
			puts( "|_____|_____|_____|".center(lineWidth))
			puts( "|     |     |     |".center(lineWidth))
			puts( "|  #{@loc[7]}  |  #{@loc[8]}  |  #{@loc[9]}  |".center(lineWidth))
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
		puts "\nIt is #{@turn}'s turn.\n"

		if @ai_mode && @turn == "X"
			move = get_ai_move
		else 
			move = get_user_move
			until move # move will return false if it has already been made.
				move = get_user_move
			end
		end
		
		if move == "exit"
			@turn = "no winner :-("
			end_game("exit")
		else
			move(move)
		end
	end

	def get_ai_move 
		available_moves = @moves_array - @move_log
		if available_moves.include?(5) && @move_log.length < 2
			move = 5 # AI always chooses middle at beginning of game as long as it's a valid move.
		else 
			move = best_ai_moves(available_moves) #else AI selects move from best available moves.
		end
		move
	end

	def get_user_move
		puts "Please state your move:\n Enter a number or type 'exit' to quit."
		move_input = gets.chomp
		if move_input == "exit"
			move = "exit"
		elsif @move_log.include?(move_input.to_i)
			puts "Move invalid: already made."
			move = false
		elsif move_input.to_i == 0
			puts "Invalid move"
			move = false
		else
			move = move_input.to_i
		end
	move
	end

	def best_ai_moves(available_moves)
		possible_dim_arrays = @win_conditions.select {|dim_array| dim_array.select {|loc| @loc[loc] != "O"}.length == 3} # gets possible winning conditions.
		moves_to_win = 1
		until moves_to_win > 3
			possible_dim_arrays.each do |dim_array| #iterates through possible win conditions to find best move. Starts by searching for move that will win in 1.
				if moves_to_win == 1 && block_player_move
					puts "AI blocked player!"
					return block_player_move
				end
				if how_much_win(dim_array).length == moves_to_win
					puts "AI went for a move to win #{moves_to_win} moves."
					return how_much_win(dim_array).shuffle[0]
				end
			end
		moves_to_win += 1
		end
		available_moves.shuffle[0] # returns random move if there are no available moves that could lead to AI victory.
	end

	def how_much_win(dim_array, player="X")
		dim_array.select {|loc| @loc[loc] != player}
	end

	def block_player_move #method will decide if player is about to win.
		puts "AI is trying to understand if player is about to win."
		move = false
		possible_dim_arrays = @win_conditions.select {|dim_array| dim_array.select {|loc| @loc[loc] != "X"}.length == 3}
		possible_dim_arrays.each do |dim_array|
				if how_much_win(dim_array, "O").length == 1 
					move = how_much_win(dim_array, "O")[0]
				end
			end
		move
	end

	def move(move)
		@move_log.push move
		puts "After #{@move_log.length} moves..."
		@loc[move] = @turn
			if win?
				set_board
				end_game("win")
			elsif @move_log.length == 9
				end_game("draw")
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

	def end_game(outcome)
		manner = case outcome
			when "win"
				"the winner was #{@turn}'s."
			when "draw"
				"was a draw."
			when "exit"
				"there was no winner."
		end
		puts "\nGAME OVER!\n The game lasted #{(Time.new - @start_time).to_i} seconds and " + manner
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