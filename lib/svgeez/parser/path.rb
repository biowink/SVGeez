module SVGeez::Parser::Path
	# Coordinates
	:relative
	:absolute

	# Kind
	:move
	:line
	:quad_curve
	:cube_curve
	:close
end

require 'svgeez/parser/path/svgcommand.rb'
require 'svgeez/parser/path/svgpath.rb'