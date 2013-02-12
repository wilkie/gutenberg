require 'minitest/spec'
require 'turn/autorun'

Turn.config do |c|
  c.trace = true
  c.natural = true
end

require 'mocha'
require "mocha/setup"
