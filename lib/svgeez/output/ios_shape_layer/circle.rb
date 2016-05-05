module SVGeez::Output::IOSShapeLayer
	class Circle < Base
		def render_element
			x = @element.attributes["cx"].to_f - @element.attributes["r"].to_f
			y = @element.attributes["cy"].to_f - @element.attributes["r"].to_f
			width = @element.attributes["r"].to_f * 2
			height = @element.attributes["r"].to_f * 2

			write "UIBezierPath *#{id} = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(#{x}, #{y}, #{width}, #{height})];"
		end
	end
end