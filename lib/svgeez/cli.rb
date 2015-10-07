require 'prawn-svg'

require 'svgeez/output'

module SVGeez
	class CLI
		attr_accessor :options

		def self.run argv
			new(Options.parse(argv)).run
		end

		def initialize options
			self.options = options
		end

		def run
			svgs = collect_svgs
			render svgs
		end

		def collect_svgs
			svgs = {}

			options.source_files.each do |source_file|
				puts "Reading #{source_file}"

				filename = source_file
				data = ''
				file = File.open(filename)
				file.each_line do |line|
					data += line
				end
				file.close

				document = Prawn::SVG::Document.new(data, {
					:cache_images => false,
				})

				calls = []
				svg = Prawn::SVG::Elements::Root.new(document.root, document)
				svg.process

				key = File.basename(source_file, ".*")
				svgs[key] = svg
			end

			svgs
		end

		def render svgs
			package = SVGeez::Output::choose_renderer "ios_layer_tree"

			renderer = package::Renderer.new(options, svgs)
			renderer.run()
		end
	end
end