require File.dirname(__FILE__) + '/../../spec_helper'

describe SVGeez::Parser::Path::SVGCommand do
	describe "close" do
		it "creates close from 0-arg init" do
			command = SVGeez::Parser::Path::SVGCommand.new
			expect(command.type).to eq :close
			expect(command.point).to be nil
			expect(command.control1).to be nil
			expect(command.control2).to be nil
		end
	end

	describe "move" do
		it "creates move from 3-arg init" do
			command = SVGeez::Parser::Path::SVGCommand.new(100, 200, :move)

			point = SVGeez::Model::Point.new(100, 200)
			expect(command.type).to eq :move
			expect(command.point).to eq point
			expect(command.control1).to eq point
			expect(command.control2).to eq point
		end
	end

	describe "line" do
		it "creates line from 3-arg init" do
			command = SVGeez::Parser::Path::SVGCommand.new(100, 200, :line)

			point = SVGeez::Model::Point.new(100, 200)
			expect(command.type).to eq :line
			expect(command.point).to eq point
			expect(command.control1).to eq point
			expect(command.control2).to eq point
		end
	end

	# "vertical line" - implicitly a line
	# "horizontal line" - implicitly a line

	describe "quadratic curve to" do
		it "creates quadratic curve to from 4-arg init" do
			command = SVGeez::Parser::Path::SVGCommand.new(1, 2, 3, 4)

			control = SVGeez::Model::Point.new(1, 2)
			expect(command.type).to eq :quad_curve
			expect(command.point).to eq SVGeez::Model::Point.new(3, 4)
			expect(command.control1).to eq control
			expect(command.control2).to eq control
		end
	end

	# "smooth quadratic curve to" - implicitly a quadratic curve to

	describe "cubic curve to" do
		it "creates cubic curve to from 4-arg init" do
			command = SVGeez::Parser::Path::SVGCommand.new(1, 2, 3, 4, 5, 6)

			control = SVGeez::Model::Point.new(1, 2)
			expect(command.type).to eq :cube_curve
			expect(command.control1).to eq SVGeez::Model::Point.new(1, 2)
			expect(command.control2).to eq SVGeez::Model::Point.new(3, 4)
			expect(command.point).to eq SVGeez::Model::Point.new(5, 6)
		end
	end

	# "smooth cubic curve to" - implicitly a cubic curve to
end
