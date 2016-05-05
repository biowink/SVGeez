module SVGeez::Output::IOSShapeLayer
	class Rect < Base
		def render_element
			x = @element.attributes["x"].to_f
			y = @element.attributes["y"].to_f
			width = @element.attributes["width"].to_f
			height = @element.attributes["height"].to_f

			write "UIBezierPath *#{id} = [UIBezierPath bezierPathWithRect:CGRectMake(#{x}, #{y}, #{width}, #{height})];"
		end
	end
end