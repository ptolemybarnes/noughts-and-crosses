def game_handler(game_options)
	output_options = Hash.new(false)
	
	game_options.each do |option, bloc|
		until output_options[option]
			output_options[option] = bloc.call
			exit if output_options[option] == "exit"
		end
	end
output_options
end
