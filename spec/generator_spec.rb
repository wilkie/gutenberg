require_relative 'helper'
require_relative '../lib/gutenberg/generator.rb'

describe Gutenberg::Generator do
  describe "#initialize" do
    it "should initialize Tilt with the style layout" do
      File.stubs(:dirname).returns("base_dir")
      Tilt.expects(:new).with("base_dir/styles/fantastic/layout.haml")
      Gutenberg::Generator.new("fantastic")
    end
  end

  describe "#render" do
    before do
      File.stubs(:dirname).returns("base_dir")

      @layout = mock('layout')
      @layout.stubs(:render).returns("layout return")

      Tilt.stubs(:new).with("base_dir/styles/fantastic/layout.haml").returns(@layout)

      @template = mock('template')
      @template.stubs(:render).returns("template return")

      Tilt.stubs(:new).with("base_dir/styles/fantastic/book.haml").returns(@template)

      Gutenberg::HTMLSupervisor.stubs(:new)

      @book = mock('book')
    end

    it "should load the book template" do
      Tilt.expects(:new).with("base_dir/styles/fantastic/book.haml").returns(@template)
      Gutenberg::Generator.new("fantastic").render(@book)
    end

    it "should render the book using the layout" do
      @layout.expects(:render)
      Gutenberg::Generator.new("fantastic").render(@book)
    end

    it "should render the book using the book template within the layout render" do
      # Welp. I need to make sure that template can be yielded within layout
      # Yet, Mocha doesn't seem to let me
      @layout.expects(:render).yields
      @template.expects(:render).returns("template return")
      Gutenberg::Generator.new("fantastic").render(@book)
    end

    it "should render the book using the book template within the layout render" do
      # Welp. I need to make sure that template can be yielded within layout
      # Yet, Mocha doesn't seem to let me. I lose all track of the information
      # within the block...
      #
      # So this test will present a false positive if the template render was
      # called outside of the block for whatever reason, but not actually
      # inside the block.
      @layout.expects(:render).yields
      @template.expects(:render).returns("template return")
      Gutenberg::Generator.new("fantastic").render(@book)
    end

    it "should use a HTMLSupervisor" do
      Gutenberg::HTMLSupervisor.expects(:new)
      Gutenberg::Generator.new("fantastic").render(@book)
    end

    it "should pass a HTMLSupervisor to layout" do
      Gutenberg::HTMLSupervisor.stubs(:new).returns("supervisor")
      @layout.expects(:render).with("supervisor")
      Gutenberg::Generator.new("fantastic").render(@book)
    end

    it "should pass a HTMLSupervisor to layout" do
      Gutenberg::HTMLSupervisor.stubs(:new).returns("supervisor")
      @layout.stubs(:render).yields
      @template.expects(:render).with("supervisor").returns("template return")
      Gutenberg::Generator.new("fantastic").render(@book)
    end
  end
end
