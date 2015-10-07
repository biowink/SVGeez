module SVGeez::Output::IOSLayerTree
	class Rect < Base
		def render_element
			x = @element.attributes["x"].to_f
			y = @element.attributes["y"].to_f
			width = @element.attributes["width"].to_f
			height = @element.attributes["height"].to_f

			write "CAShapeLayer *#{id} = [CAShapeLayer layer];"
			write "#{id}.path = [UIBezierPath bezierPathWithRect:CGRectMake(#{x}, #{y}, #{width}, #{height})].CGPath;"
		end
	end
end