require 'svgeez/parser/path'

module SVGeez::Output::IOSLayerTree
	class Polyline < Base
		attr_accessor :svg_path

		def initialize(element)
			super(element)

			# According to SVG spec, a 'polygon' is EXACTYLY IDENTICAL to a 'path', if you prepend the letter "M", and postfix the letter 'z'.
 			# So, we take the complicated parser from SVGPathElement, remove all the multi-command stuff, and just use the "M" command
 			s = element.attributes["points"].to_s.strip.gsub(/\s+/, 'L')
			s = "M#{s}z"
			@svg_path = SVGeez::Parser::Path::SVGPath.new(s)
		end

		def apply_commands
			@svg_path.commands.each do |command|
				case command.type
				when :move
					render_move_to_point command.point
				when :line
					render_add_line_to_point command.point
				when :close
					render_close_path
				end
			end
		end

		def render_element
			write "CAShapeLayer *#{id} = [CAShapeLayer layer];"
			write "UIBezierPath *#{id}_Path = [UIBezierPath bezierPath];"

			apply_commands

			write "#{id}.path = #{id}_Path.CGPath;"
		end

		def rnd float
			('%.4f' % float).sub!(/[0]+$/, '')
		end

		def render_move_to_point point
			write "[#{id}_Path moveToPoint:CGPointMake(#{rnd(point.x)}, #{rnd(point.y)})];"
		end

		def render_add_line_to_point point
			write "[#{id}_Path addLineToPoint:CGPointMake(#{rnd(point.x)}, #{rnd(point.y)})];"
		end

		def render_close_path
			write "[#{id}_Path closePath];"
		end
	end
end