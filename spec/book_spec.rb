require_relative 'helper'
require_relative '../lib/gutenberg/book.rb'

describe Gutenberg::Book do
  it "can be created with no arguments" do
    Gutenberg::Book.new.must_be_instance_of Gutenberg::Book
  end

  it "can be created with a title" do
    Gutenberg::Book.new({:title => "My Book"}).title.must_equal("My Book")
  end

  it "can be created with an author" do
    Gutenberg::Book.new({:authors => ["wilkie"]})
      .authors.first.must_equal("wilkie")
  end

  it "can be created with style" do
    Gutenberg::Book.new({:style => "really_pretty"})
      .style.must_equal("really_pretty")
  end

  it "title can be pulled from yaml" do
    YAML.stubs(:load_file).returns({"title" => "Book Title"})
    Gutenberg::Book.new({:yaml => 'test.yaml'}).title.must_equal("Book Title")
  end

  it "authors can be pulled from yaml" do
    YAML.stubs(:load_file).returns({"authors" => ["wilkie", "smith"]})
    Gutenberg::Book.new({:yaml => 'test.yaml'}).authors.must_equal(["wilkie", "smith"])
  end

  it "style can be pulled from yaml" do
    YAML.stubs(:load_file).returns({"style" => "pretty"})
    Gutenberg::Book.new({:yaml => 'test.yaml'}).style.must_equal("pretty")
  end

  it "chapters can be pulled from yaml" do
    YAML.stubs(:load_file).returns({"chapters" => ["foo"]})
    Gutenberg::Chapter.expects(:new).with({:markdown_file => "foo"}).returns("CHAPTER")
    Gutenberg::Book.new({:yaml => "test.yaml"}).chapters.must_equal(["CHAPTER"])
  end

  it "has a reasonable default title" do
    Gutenberg::Book.new.title.must_equal("Untitled")
  end

  it "has a reasonable default list of authors" do
    Gutenberg::Book.new.authors.must_equal(["anonymous"])
  end

  it "has a reasonable default style" do
    Gutenberg::Book.new.style.must_equal("basic")
  end

  it "has an empty list of chapters by default" do
    Gutenberg::Book.new.chapters.must_equal([])
  end

  it "has a reasonable default title when not specified in yaml" do
    YAML.stubs(:load_file).returns({"style" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).title.must_equal("Untitled")
  end

  it "has a reasonable default list of authors when not specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).authors.must_equal(["anonymous"])
  end

  it "has a reasonable default style when not specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).style.must_equal("basic")
  end

  it "has an empty list of chapters by default when not specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).chapters.must_equal([])
  end

  it "can override the title that is specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml", :title => "bar"}).title.must_equal("bar")
  end

  it "can override the authors that are specified in yaml" do
    YAML.stubs(:load_file).returns({"authors" => ["foo"]})
    Gutenberg::Book.new({:yaml => "test.yaml", :authors => ["bar"]}).authors.must_equal(["bar"])
  end

  it "can override the style that is specified in yaml" do
    YAML.stubs(:load_file).returns({"style" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml", :style => "bar"}).style.must_equal("bar")
  end

  it "can override the chapters that are specified in yaml" do
    YAML.stubs(:load_file).returns({"chapters" => ["foo"]})
    Gutenberg::Chapter.expects(:new).with({:markdown_file => "bar"}).returns("CHAPTER")
    Gutenberg::Book.new({:yaml => "test.yaml", :chapters => ["bar"]}).chapters.must_equal(["CHAPTER"])
  end

  it "creates a Chapter object for a listed chapter" do
    c = Gutenberg::Chapter.new
    Gutenberg::Chapter.expects(:new).with({:markdown_file => "foo"}).returns(c)
    Gutenberg::Book.new({:chapters => ["foo"]})
      .chapters.first.must_be_instance_of(Gutenberg::Chapter)
  end
end
