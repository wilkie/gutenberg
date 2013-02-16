require_relative 'helper'
require_relative '../lib/gutenberg/html_supervisor.rb'

describe Gutenberg::HTMLSupervisor do
  describe "#initialize" do
    it "can retrieve the book used upon creator" do
      Gutenberg::Book.stubs(:new).returns(mock('book'))
      Gutenberg::HTMLSupervisor.new(Gutenberg::Book.new)
    end
  end
end
