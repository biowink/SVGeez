module SVGeez::Output::IOSLayerTree
	class SVG < Base
		def id
			"svg"
		end

		def render_element
			x1, y1, x2, y2 = element.attributes["viewbox"].split(" ").collect { |n| n.to_f }

			write "CALayer *#{id} = [CALayer layer];"
			write "#{id}.frame = CGRectMake(#{x1}, #{y1}, #{x2}, #{x2});"
		end
	end
end