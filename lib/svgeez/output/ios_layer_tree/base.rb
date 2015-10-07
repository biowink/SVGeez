module SVGeez::Output::IOSLayerTree
	class Base
		attr_accessor :element, :writer

		def initialize element
			@element = element
		end

		def write s = nil
			if @writer then
				@writer.write s
			else
				puts s
			end
		end

		def add_child child
			return if not child

			write
			write "[#{id} addSublayer:#{child.id}];"
		end

		def id
			return @id if @id

			@id = element.source.attributes["id"]
			@id = "#{element.name}_#{writer.indent}_#{writer.idx}" if not @id

			# sanity
			@id.gsub(/[^0-9a-z]/i, '_')

			@id
		end

		def render
			if element.attributes["id"] then
				write "// <#{element.name}>: #{id}"
			else
				write "// <#{element.name}>"
			end

			render_element
			render_transforms
		end

		def render_element
		end

		def render_transforms
			# TODO more than one, lols. combine 'em.

			return unless element.transforms.count > 0

			transform = element.transforms.first

			case transform.type
			# TODO other scale types

			when :matrix
				write "#{id}.transform = CATransform3DMakeAffineTransform(CGAffineTransformMake(#{transform.numbers[0]}, #{transform.numbers[1]}, #{transform.numbers[2]}, #{transform.numbers[3]}, #{transform.numbers[4]}, #{transform.numbers[5]}));"
			end

			# element.transforms.each do |transform|
			# 	puts transform.type
			# end
		end
	end
end