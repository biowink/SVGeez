module SVGeez::Model
	class Point
		attr_accessor :x, :y

		def initialize(x = nil, y = nil)
			@x = x
			@y = y
		end

		def + other
			Point.new(@x + other.x, @y + other.y)
		end

		def - other
			Point.new(@x - other.x, @y - other.y)
		end
	end
end
