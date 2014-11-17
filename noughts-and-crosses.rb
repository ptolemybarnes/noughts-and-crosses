# How to define a board? a 2D array.
# How to define a piece? A piece should have: 1) location.


class NoughtsAndCrosses

	def initialize
		@start_time = Time.new
		@move_log = Array.new
		@turn = "O"
		@winner = "no winner :-("

		@loc = {
		a_3: " ",
		b_3: " ",
		c_3: " ",
		a_2: " ",
		b_2: " ",
		c_2: " ",
		a_1: " ",
		b_1: " ",
		c_1: " ",
	}

	@win_conditions = [
		[:a_3, :b_3, :c_3],[:a_2, :b_2, :c_2],[:a_1, :b_1, :c_1], #rows
		[:a_1, :a_2, :a_3],[:b_1, :b_2, :b_3],[:c_1, :c_2, :c_3], #columns
		[:a_1, :b_2, :c_3],[:c_1, :b_2, :a_3]] #diagonals

	@board = Proc.new do
			puts "___________________"
			puts "|     |     |     |"
			puts "|  #{@loc[:a_3]}  |  #{@loc[:b_3]}  |  #{@loc[:c_3]}  |"
			puts "|_____|_____|_____|"
			puts "|     |     |     |"
			puts "|  #{@loc[:a_2]}  |  #{@loc[:b_2]}  |  #{@loc[:c_2]}  |"
			puts "|_____|_____|_____|"
			puts "|     |     |     |"
			puts "|  #{@loc[:a_1]}  |  #{@loc[:b_1]}  |  #{@loc[:c_1]}  |"
			puts "|_____|_____|_____|"
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

		move = gets.chomp.intern # gets user's move.
		
		if @loc.has_key?(move) && !@move_log.include?(move) # ensures move requested by user is valid and has not been made before.
			self.move = move
		elsif move == :exit
			end_game
		else
			puts "Not a valid move."
			moveprompt
		end
	end

	def move=(move)
		@move_log.push move
		puts "\nAfter #{@move_log.length} moves..."
		@loc[move] = @turn
			if win?
				@winnner = @turn
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

private

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

game = NoughtsAndCrosses.new