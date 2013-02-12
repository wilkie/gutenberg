require 'minitest/spec'
require 'turn/autorun'

require_relative '../lib/gutenberg/chapter.rb'

describe Gutenberg::Chapter do
  it "can be created with no arguments" do
    Gutenberg::Chapter.new.must_be_instance_of Gutenberg::Chapter
  end
end

