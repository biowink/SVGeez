module SVGeez::Output::IOSLayerTree
	class Container < Base
		def render_element
			write "CALayer *#{id} = [CALayer layer];"
		end
	end
end