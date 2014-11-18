class NoughtsAndCrosses

	def initialize(game_options)
		game_options[:mode] == "ai-mode" ? @ai_mode = true : @ai_mode = false
		@difficulty = game_options[:difficulty]
		@rounds = game_options[:rounds]
		@rounds_played = 0
		@score = {
			"X" => 0,
			"O" => 0
		}
		lineWidth = 80

		set_game
		puts "\n Flipping for start..."
		rand(2) == 0 ? @turn = "O" : @turn = "X" # flips for start.
		puts "#{@turn}s will start the game!\n"
		@moves_array = @loc.keys #makes an array of moves available for the AI.

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

	@get_score = Proc.new do
			puts " X : #{@score["X"]}"
			puts " O : #{@score["O"]}"
		end

	moveprompt
	end

	def set_game	
		puts "Let the game begin!!!"

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

	@start_time = Time.new
	@move_log = Array.new
	end

	def moveprompt
		@board.call
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
			end_game("exit")
		else
			move(move)
		end
	end

	def get_ai_move 
		available_moves = @moves_array - @move_log
		# if difficulty settings are engaged, AI will sometimes randomly select moves rather than calculating the best move.
		if @difficulty == 2 && rand(6) == 5
			move = available_moves.shuffle[0] 
		elsif @difficulty == 1 && rand(4) == 3
			move = available_moves.shuffle[0] 
			puts 'AI chose a random move.'
		elsif available_moves.include?(5) && @move_log.length < 2
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

###### This section provides AI functionality

	def best_ai_moves(available_moves)
		possible_dim_arrays = @win_conditions.select {|dim_array| dim_array.select {|loc| @loc[loc] != "O"}.length == 3} # gets possible winning conditions.
		moves_to_win = 1
		until moves_to_win > 3
			possible_dim_arrays.each do |dim_array| #iterates through possible win conditions to find best move. Starts by searching for move that will win in 1.
				if moves_to_win > 1 && block_player_move # will try to block player if it cannot win in one move.
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

###### End of AI section.

	def move(move)
		@move_log.push move
		puts "After #{@move_log.length} moves..."
		@loc[move] = @turn
			if win?
				@board.call
				end_game("win")
			elsif @move_log.length == 9
				@board.call
				end_game("draw")
			else
				turn_switch(@turn)
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

	def turn_switch(turn)
		if turn == "X"
			@turn = "O"
		else
			@turn = "X"
		end
	end

	def end_game(outcome)
		@rounds_played += 1
		case outcome
			when "win"
				manner = "the winner was #{@turn}'s."
				@score[@turn] += 1
				@turn = turn_switch(@turn) # so loser will start next round.
			when "draw"
				manner = "was a draw."
				@turn = turn_switch(@turn)
			when "exit"
				manner = "there was no winner."
		end
		
		puts "\nGAME OVER!\n The game lasted #{(Time.new - @start_time).to_i} seconds and " + manner
		
		if @rounds_played == @rounds || manner == "exit"
			end_match
		else
			reset_game
		end
	end

	def reset_game
		puts "The score is:"
		@get_score.call
		puts "Resetting game..."
		set_game
		moveprompt
	end

	def end_match
		puts "\nMatch complete. The final score was:"
		@get_score.call
		puts ""
		case @score["X"] <=> @score["O"]
			when 0
				puts "The match was a draw."
			when 1
				puts "Xs is the victor!"
			when -1
				puts "Os is the victor!"
		end
	end
end

def game_starter

	game_options = {
		mode: false,
		difficulty: false,
		rounds: false
	}

	until game_options[:mode] # offer game options until player selects a valid one or exits.
		puts "Options:"
			puts " Enter 1 for two-player mode.\n"
			puts " Enter 2 to play against the AI.\n"
			puts " Enter 'exit' to quit."
		mode_choice = gets.chomp
		
		if mode_choice == "1"
			game_options[:mode] = "two-player"

		elsif mode_choice == "2"
			game_options[:mode] = "ai-mode"

			until game_options[:difficulty] # select difficulty of AI mode.
				puts "Please choose a difficulty:\n Enter 3 for hard mode. \n Enter 2 for normal \n Enter 1 for easy mode."
				difficulty_choice = gets.chomp.to_i
				if difficulty_choice == (3 || 2) || 1
					game_options[:difficulty] = difficulty_choice
				end
			end

		elsif mode_choice == "exit"
			return
		else
			puts "Invalid option.\n"
		end
	end

	until game_options[:rounds] # select number of rounds.
		puts "Please input number of rounds to play..."
		rounds_choice = gets.chomp.to_i
		if rounds_choice > 0 && rounds_choice.odd?
			game_options[:rounds] = rounds_choice
		else
			puts "Enter an odd number greater than 0."
		end
	end
	NoughtsAndCrosses.new(game_options)
end

game_starter