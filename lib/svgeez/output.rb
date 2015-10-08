require 'tilt'

module SVGeez::Output
	UnknownRenderer = Class.new(StandardError)

	def self.choose_renderer renderer
		require "svgeez/output/#{renderer}"

		case renderer
		when "ios_layer_tree"
			return SVGeez::Output::IOSLayerTree
		when "ios_shape_layer"
			return SVGeez::Output::IOSShapeLayer
		else
			raise UnknownRenderer, "Unknown renderer '#{renderer}"
		end
	end
end