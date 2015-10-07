# hi from https://github.com/timrwood/SVGPath/blob/master/SVGPath/SVGPath.swift

require 'svgeez/model/point'

module SVGeez::Parser::Path
	class SVGPath
		attr_accessor :commands, :builder, :coords, :stride, :numbers

		def initialize string
			# Mm - Move
			move_to = Proc.new do |numbers, last, coords|
				SVGCommand.new(numbers[0], numbers[1], :move)
			end

			# Ll - Line
			line_to = Proc.new do |numbers, last, coords|
				SVGCommand.new(numbers[0], numbers[1], :line)
			end

			# Vv - Vertical Line
			line_to_vertical = Proc.new do |numbers, last, coords|
				last_point = last.point if last && last.point
				SVGCommand.new(coords == :absolute ? last_point.x : 0, numbers[0], :line)
			end

			# Hh - Horizontal Line
			line_to_horizontal = Proc.new do |numbers, last, coords|
				last_point = last.point if last && last.point
				SVGCommand.new(numbers[0], coords == :absolute ? last_point.y : 0, :line)
			end

			# Qq - Quadratic Curve To
			quad_broken = Proc.new do |numbers, last, coords|
				SVGCommand.new(numbers[0], numbers[1], numbers[2], numbers[3])
			end

			# Tt - Smooth Quadratic Curve To
			quad_smooth = Proc.new do |numbers, last, coords|
				last_control = last.control1 || SVGeez::Model::Point.new
				last_point = last.point || SVGeez::Model::Point.new
				if last.type != :quad_curve then
					last_control = last_point
				end

				control = last_point - last_control
				if coords == :absolute then
					control = control + last_point
				end

				SVGCommand.new(control.x, control.y, numbers[0], numbers[1])
			end

			# Cc - Cubic Curve To
			cube_broken = Proc.new do |numbers, last, coords|
				SVGCommand.new(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4], numbers[5])
			end

			# Ss - Smooth Cubic Curve To
			cube_smooth = Proc.new do |numbers, last, coords|
				last_control = last.control2 || SVGeez::Model::Point.new
				last_point = last.point || SVGeez::Model::Point.new
				if last.type != :cube_curve then
					last_control = last_point
				end

				control = last_point - last_control
				if coords == :absolute then
					control = control + last_point
				end

				SVGCommand.new(control.x, control.y, numbers[0], numbers[1], numbers[2], numbers[3])
			end

			# Zz - Close Path
			close = Proc.new do |numbers, last, coords|
				SVGCommand.new
			end

			@commands = []
			@numbers = ""

			string.each_char do |char|
				case char
				when "M"; use(:absolute, 2, move_to)
				when "m"; use(:relative, 2, move_to)
				when "L"; use(:absolute, 2, line_to)
				when "l"; use(:relative, 2, line_to)
				when "V"; use(:absolute, 1, line_to_vertical)
				when "v"; use(:relative, 1, line_to_vertical)
				when "H"; use(:absolute, 1, line_to_horizontal)
				when "h"; use(:relative, 1, line_to_horizontal)
				when "Q"; use(:absolute, 4, quad_broken)
				when "q"; use(:relative, 4, quad_broken)
				when "T"; use(:absolute, 2, quad_smooth)
				when "t"; use(:relative, 2, quad_smooth)
				when "C"; use(:absolute, 6, cube_broken)
				when "c"; use(:relative, 6, cube_broken)
				when "S"; use(:absolute, 4, cube_smooth)
				when "s"; use(:relative, 4, cube_smooth)
				when "Z"; use(:absolute, 1, close)
				when "z"; use(:absolute, 1, close)
				when /\s/; # ???
				else; @numbers += char
				end
			end

			finish_last_command
		end

		def use coords, stride, builder
			finish_last_command

			@coords = coords
			@stride = stride
			@builder = builder
		end

		def finish_last_command
			take(SVGPath.parse_numbers(@numbers), @stride, @coords, @commands.last, @builder).each do |command|
				command = command.relative_to(@commands.last) if @coords == :relative
				@commands.push command
			end
			@numbers = ""
		end

		def take numbers, stride, coords, last, callback
			return [] if not callback

			out = []
			last_command = last

			count = (numbers.length / stride) * stride

			(0...count).step(stride) do |i|
				last_command = callback.call(numbers[0..(i+stride)], last_command, coords)
				out.push last_command
			end

			out
		end

		def self.parse_numbers numbers_string
			number_set = "-.0123456789eE"

			all = []
			curr = ""
			last = ""

			numbers_string.each_char do |char|
				if char == "-" && last != "" && last != "E" && last != "e" then
					all.push curr if curr.length > 0
					curr = char
				elsif number_set.include?(char) then
					curr += char
				elsif curr.length > 0 then
					all.push curr
					curr = ""
				end
				last = char
			end

			all.push(curr)

			all.map do |x|
				x.to_f
			end
		end
	end
end