module SVGeez::Output::IOSLayerTree
	class Ellipse < Base
		def render_element
			x = @element.attributes["cx"].to_f - @element.attributes["rx"].to_f
			y = @element.attributes["cy"].to_f - @element.attributes["ry"].to_f
			width = @element.attributes["rx"].to_f * 2
			height = @element.attributes["ry"].to_f * 2

			write "CAShapeLayer *#{id} = [CAShapeLayer layer];"
			write "#{id}.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(#{x}, #{y}, #{width}, #{height})].CGPath;"
		end
	end
end