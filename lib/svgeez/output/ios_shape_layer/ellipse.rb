module SVGeez::Output::IOSShapeLayer
	class Ellipse < Base
		def render_element
			x = @element.attributes["cx"].to_f - @element.attributes["rx"].to_f
			y = @element.attributes["cy"].to_f - @element.attributes["ry"].to_f
			width = @element.attributes["rx"].to_f * 2
			height = @element.attributes["ry"].to_f * 2

			write "UIBezierPath *#{id} = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(#{x}, #{y}, #{width}, #{height})];"
		end
	end
end