require 'optparse'

module SVGeez
	class Options
		attr_accessor(
			:dry_run,
			:output_file,
			:source_files,

			# TODO:
			#  - multiple input files
			#  - swift vs objc vs java blah
			#  - template
		)

		def self.parse argv
			options = self.new
			options.dry_run = true

			optparse = OptionParser.new do |opts|
				opts.banner = "#{File.basename($PROGRAM_NAME)}: SVG to UIBezierPath thing"
				opts.define_head "Usage: #{File.basename($PROGRAM_NAME)} source_file(s) [options]"
				opts.separator ''
				opts.separator 'Options:'

				opts.on('-d', '--dry-run', 'Output to STDOUT') do |dry_run|
					options.dry_run = dry_run
				end

				opts.on('-o', '--output_file FILE', 'Destination file') do |output_file|
					options.dry_run = false
					options.output_file = output_file
				end

				opts.on_tail("-?", "--help", "Show this message") do
					puts opts
					exit
				end
			end

			optparse.parse!(argv)

			if argv.first.nil?
				puts optparse
				exit
			else
				options.source_files = argv
			end

			options
		end
	end
end