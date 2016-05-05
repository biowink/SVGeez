require 'svgeez/parser/path'

module SVGeez::Output::IOSShapeLayer
	class Path < Base
		attr_accessor :svg_path

		def initialize(element)
			super(element)

			@svg_path = SVGeez::Parser::Path::SVGPath.new(element.attributes["d"])
		end

		def apply_commands
			commands = unfuck_commands @svg_path.commands

			commands.each do |command|
				case command.type
				when :move
					render_move_to_point command.point
				when :line
					render_add_line_to_point command.point
				when :quad_curve
					render_add_quad_curve_to_point command.point, command.control1
				when :cube_curve
					render_add_curve_to_point command.point, command.control1, command.control2
				when :close
					render_close_path
				end
			end
		end

		def render_element
			write "UIBezierPath *#{id} = [UIBezierPath bezierPath];"

			apply_commands
		end

		def rnd float
			('%.4f' % float).sub!(/[0]+$/, '')
		end

		def render_move_to_point point
			write "[#{id} moveToPoint:CGPointMake(#{rnd(point.x)}, #{rnd(point.y)})];"
		end

		def render_add_line_to_point point
			write "[#{id} addLineToPoint:CGPointMake(#{rnd(point.x)}, #{rnd(point.y)})];"
		end

		def render_add_quad_curve_to_point point, control
			write "[#{id} addQuadCurveToPoint:CGPointMake(#{rnd(point.x)}, #{rnd(point.y)}) controlPoint:CGPointMake(#{rnd(control.x)}, #{rnd(control.y)})];"
		end

		def render_add_curve_to_point point, control1, control2
			write "[#{id} addCurveToPoint:CGPointMake(#{rnd(point.x)}, #{rnd(point.y)}) controlPoint1:CGPointMake(#{rnd(control1.x)}, #{rnd(control1.y)}) controlPoint2:CGPointMake(#{rnd(control2.x)}, #{rnd(control2.y)})];"
		end

		def render_close_path
			write "[#{id} closePath];"
		end
	end
end