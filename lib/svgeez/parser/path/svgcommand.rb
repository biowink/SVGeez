# hi from https://github.com/timrwood/SVGPath/blob/master/SVGPath/SVGPath.swift

require 'svgeez/model/point'

module SVGeez::Parser::Path
	class SVGCommand
		attr_accessor :point, :type, :control1, :control2

		def initialize(*args)
			case args.length
			when 0
				@control1 = nil
				@control2 = nil
				@point = nil
				@type = :close
			when 3
				point = SVGeez::Model::Point.new(args[0], args[1])
				@control1 = point
				@control2 = point
				@point = point
				@type = args[2]
			when 4
				if args[0].instance_of?(SVGeez::Model::Point) &&
					args[1].instance_of?(SVGeez::Model::Point) &&
					args[2].instance_of?(SVGeez::Model::Point) then

					@control1 = args[0]
					@control2 = args[1]
					@point = args[2]
					@type = args[3]
				else
					# quad curve
					control = SVGeez::Model::Point.new(args[0], args[1])
					@control1 = control
					@control2 = control
					@point = SVGeez::Model::Point.new(args[2], args[3])
					@type = :quad_curve
				end
			when 6
				@control1 = SVGeez::Model::Point.new(args[0], args[1])
				@control2 = SVGeez::Model::Point.new(args[2], args[3])
				@point = SVGeez::Model::Point.new(args[4], args[5])
				@type = :cube_curve
			end
		end

		def relative_to other
			return self if not other.point
			SVGCommand.new(@control1 + other.point, @control2 + other.point, @point + other.point, @type)
		end
	end
end