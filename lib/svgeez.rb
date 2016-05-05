require 'rubygems'

$:.push File.expand_path('../../vendor/prawn-svg/lib', __FILE__)

module SVGeez
end

require 'svgeez/cli'
require 'svgeez/model'
require 'svgeez/options'
require 'svgeez/parser'
require 'svgeez/version'