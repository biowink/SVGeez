require 'erb'

require 'svgeez/parser/path/svgpath'

module SVGeez::Output::IOSLayerTree
	class Renderer
		attr_accessor :options, :svgs

		def initialize options, svgs = {}
			self.options = options
			self.svgs = svgs
		end

		def path_for tpl
			File.dirname(__FILE__) + "/ios_layer_tree/#{tpl}"
		end

		def run
			svg_templates = {}
			svgs.each do |key, svg|
				svg_templates[key] = templatify_element svg
			end

			timestamp = Time.now
			vars = {
				:svgs => @svgs,
				:svg_templates => svg_templates,
				:timestamp => timestamp,
				}

			template_h = Tilt.new(path_for('main_h.erb'))
			template_m = Tilt.new(path_for('main_m.erb'))
			h = template_h.render(self, vars)
			m = template_m.render(self, vars)

			if options.dry_run then
				puts m
			else 
				fo_h = File.open(options.output_file + ".h", "w")
				fo_m = File.open(options.output_file + ".m", "w")

				fo_h << h
				fo_m << m

				fo_h.close
				fo_m.close
			end
		end

		def templatify_element source_element, parent_id = nil, level = 0, index = 0
			if source_element.source.name == "use" then
				element = source_element.linked_element
			else
				element = source_element
			end

			if "none" == element.state[:display]
				return nil
			end

			id = source_element.source.attributes["id"]
			id = "#{element.name}_#{level}_#{index}" if not id

			# sanity
			id.gsub(/[^0-9a-z]/i, '_')

			case element.source.name
			when "svg"
				element_tpl = Tilt.new path_for('element/svg.erb')
			when "circle"
				element_tpl = Tilt.new path_for('element/circle.erb')
			when "ellipse"
				element_tpl = Tilt.new path_for('element/ellipse.erb')
			when "g"
				element_tpl = Tilt.new path_for('element/container.erb')
			when "path"
				element_tpl = Tilt.new path_for('element/path.erb')
			when "polygon"
				element_tpl = Tilt.new path_for('element/polygon.erb')
			when "polyline"
				element_tpl = Tilt.new path_for('element/polyline.erb')
			when "rect"
				element_tpl = Tilt.new path_for('element/rect.erb')
			end

			if not element_tpl then
				return nil
			end

			transform_tpl = Tilt.new path_for('transform.erb')

			params = {
				:element   => element,
				:id        => id,
				:parent_id => parent_id,
			}

			element_output = element_tpl.render(nil, params)
			transform_output = transform_tpl.render(nil, params)

			level += 1
			output = Tilt.new(path_for('element.erb')).render(nil, params.merge({
				:element_output => element_output.gsub!(/^/, "\t"),
				:transform_output => transform_output,
			})) {
				# recurse through children
				children_code = ''
				element.children.each_index do |idx|
					child = element.children[idx]
					
					child_code = templatify_element child, id, level, idx

					if child_code then
						children_code += child_code
					end
				end

				children_code
			}
			level -= 1

			output.gsub!(/^/, "\t") if level > 0

			output
		end
	end
end

# %w(base circle container ellipse path polygon polyline rect svg).each do |filename|
#   require "svgeez/output/ios_layer_tree/#{filename}"
# end
