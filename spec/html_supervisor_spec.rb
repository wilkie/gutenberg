require_relative 'helper'
require_relative '../lib/gutenberg/html_supervisor.rb'

describe Gutenberg::HTMLSupervisor do
  describe "#initialize" do
    it "can retrieve the book used upon creator" do
      book = mock('book')
      book.stubs(:style).returns(mock('style'))
      Gutenberg::Book.stubs(:new).returns(book)
      Gutenberg::HTMLSupervisor.new(Gutenberg::Book.new).book.must_equal book
    end

    it "can retrieve the style using the property" do
      book = mock('book')
      book.stubs(:style).returns("style")
      Gutenberg::Book.stubs(:new).returns(book)
      Gutenberg::HTMLSupervisor.new(Gutenberg::Book.new).style.must_equal "style"
    end
  end
end
