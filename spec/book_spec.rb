require 'minitest/spec'
require 'turn/autorun'

require_relative '../lib/gutenberg/book.rb'

describe Gutenberg::Book do
  it "can be created with no arguments" do
    Gutenberg::Book.new.must_be_instance_of Gutenberg::Book
  end

  it "can be created with a title" do
    Gutenberg::Book.new({:title => "My Book"}).title.must_equal("My Book")
  end
end
