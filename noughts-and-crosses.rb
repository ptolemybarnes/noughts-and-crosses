# How to define a board? a 2D array.
# How to define a piece? A piece should have: 1) location.

class NoughtsAndCrosses

	def initialize
		@start_time = Time.new
		@moves = []	
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
		puts "Let the game begin!!!" if @moves.length == 0
		@board.call
	end

	def moveprompt
		set_board
		puts "\nPlease state your move:"
		move = gets.chomp.intern
		if @loc.has_key?(move)
			makemove(move)
		elsif move = :exit
			end_game
		else
			puts "Not a valid move."
			moveprompt
		end
	end

	def makemove(move)
		@moves.push move
		puts "\nAfter #{@moves.length} moves..."
		@loc[move] = "X"
		moveprompt
	end

	def display_moves(moves)
	end

private

	def end_game
		puts "\nGAME OVER!\n Bye!"
	end

end

game = NoughtsAndCrosses.new