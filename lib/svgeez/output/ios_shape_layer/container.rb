module SVGeez::Output::IOSShapeLayer
	class Container < Base
		def render_element
			write "UIBezierPath *#{id} = [UIBezierPath bezierPath];"
		end
	end
end