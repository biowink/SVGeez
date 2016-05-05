require File.dirname(__FILE__) + '/../spec_helper'

describe SVGeez::Model::Point do
  describe "defaults" do
    it "defaults to 0" do
      point = SVGeez::Model::Point.new
      expect(point.x).to eq 0
      expect(point.y).to eq 0
    end
  end

  describe "::==" do
    it "equals values" do
      a = SVGeez::Model::Point.new(10, 20)
      b = SVGeez::Model::Point.new(10, 20)
      expect(a == b).to be true
    end

    it "not equals values" do
      a = SVGeez::Model::Point.new(10, 20)
      b = SVGeez::Model::Point.new(100, 200)
      expect(a == b).to be false
    end
  end

  describe "::+" do
    it "adds positive values" do
      point = SVGeez::Model::Point.new(10, 20) + SVGeez::Model::Point.new(100, 200)
      expect(point.x).to eq 110
      expect(point.y).to eq 220
    end

    it "adds negative values" do
      point = SVGeez::Model::Point.new(-10, -20) + SVGeez::Model::Point.new(-100, -200)
      expect(point.x).to eq -110
      expect(point.y).to eq -220
    end
  end

  describe "::-" do
    it "subtracts values" do
      point = SVGeez::Model::Point.new(100, 200) - SVGeez::Model::Point.new(10, 20)
      expect(point.x).to eq 90
      expect(point.y).to eq 180
    end
  end
end
