require 'minitest/spec'
require 'turn/autorun'

require_relative '../lib/gutenberg/chapter.rb'

describe Gutenberg::Chapter do
  it "can be created with no arguments" do
    Gutenberg::Chapter.new.must_be_instance_of Gutenberg::Chapter
  end

  it "can be created with a title" do
    Gutenberg::Chapter.new({:title => "Book Chapter"}).title.must_equal("Book Chapter")
  end

  it "can be created with an author" do
    Gutenberg::Chapter.new({:authors => ["wilkie"]})
      .authors.first.must_equal("wilkie")
  end

  it "has a reasonable default title" do
    Gutenberg::Chapter.new.title.must_equal("Untitled")
  end

  it "has a empty list of authors by default" do
    Gutenberg::Chapter.new.authors.must_equal([])
  end
end

