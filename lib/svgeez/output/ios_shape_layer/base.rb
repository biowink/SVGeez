module SVGeez::Output::IOSShapeLayer
	class Base
		attr_accessor :element, :writer, :reverse

		def initialize element
			@element = element
		end

		def write s = nil
			if @writer then
				@writer.write s
			else
				puts s
			end
		end

		def add_child child
			return if not child
			# return if child.element.name == "g"

			write

			if child.reverse then
				write "[#{id} appendPath:[#{child.id} bezierPathByReversingPath]];"
			else 
				write "[#{id} appendPath:#{child.id}];"
			end
		end

		def id
			return @id if @id

			@id = element.source.attributes["id"]
			@id = "#{element.name}_#{writer.indent}_#{writer.idx}" if not @id

			# sanity
			@id.gsub(/[^0-9a-z]/i, '_')

			@id
		end

		def render
			if element.attributes["id"] then
				write "// <#{element.name}>: #{id}"
			else
				write "// <#{element.name}>"
			end

			render_element
			render_transforms
		end

		def render_element
		end

		def render_transforms
			# # TODO more than one, lols. combine 'em.

			return unless element.transforms.count > 0

			transform = element.transforms.first

			case transform.type
			# TODO other scale types

			when :matrix
				write "[#{id} applyTransform:CGAffineTransformMake(#{transform.numbers[0]}, #{transform.numbers[1]}, #{transform.numbers[2]}, #{transform.numbers[3]}, #{transform.numbers[4]}, #{transform.numbers[5]})];"
			end
		end

		def unfuck_commands commands
			# return commands

			# if commands.count > 1 then
				# if commands[0].point.x > commands[1].point.x then
				if is_clockwise(commands)
					write "// REVERSE!"
					@reverse = true
					# commands.reverse!

					# close = false

					# if commands.first.type == :close then
					# 	close = commands.first
					# 	commands.delete close
					# end

					# if commands.last.type == :move then
					# 	command = commands.last
					# 	commands.delete command
					# 	commands.unshift command
					# end

					# if close then
					# 	commands.push close
					# end
				end
			# 	end
			# end

			commands
		end

		def is_clockwise commands
			last_move_to = nil
			last_point = nil
			sum = 0

			commands.each do |command|
				case command.type
				when :move
					last_move_to = command.point
					last_point = last_move_to
				when :line
					sum += calculate_area command.point, last_point
					last_point = command.point
				when :quad_curve
					sum += calculate_area command.point, last_point
					sum += calculate_area command.control1, command.point
					last_point = command.control1
				when :cube_curve
					sum += calculate_area command.point, last_point
					sum += calculate_area command.control1, command.point
					sum += calculate_area command.control2, command.control1
					last_point = command.control2
				when :close
					sum += calculate_area last_move_to, last_point
					last_move_to = command.point
					last_point = last_move_to
				end
			end

			sum >= 0
		end

		def calculate_area p1, p2
			return (p2.x - p1.x) * (p2.y + p1.y)
		end
	end
end