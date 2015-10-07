module SVGeez::Output::IOSLayerTree
	class Circle < Base
		def render_element
			x = @element.attributes["cx"].to_f - @element.attributes["r"].to_f
			y = @element.attributes["cy"].to_f - @element.attributes["r"].to_f
			width = @element.attributes["r"].to_f * 2
			height = @element.attributes["r"].to_f * 2

			write "CAShapeLayer *#{id} = [CAShapeLayer layer];"
			write "#{id}.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(#{x}, #{y}, #{width}, #{height})].CGPath;"
		end
	end
end