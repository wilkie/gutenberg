require_relative 'helper'
require_relative '../lib/gutenberg/node.rb'

describe Gutenberg::Node do
  describe "#initialize" do
    it "stores the given text" do
      Gutenberg::Node.new("foo").text.must_equal("foo")
    end

    it "stores the given parent" do
      Gutenberg::Node.new("foo", Gutenberg::Node.new("bar")).parent.text.must_equal("bar")
    end

    it "stores the given sibling" do
      Gutenberg::Node.new("foo", nil, Gutenberg::Node.new("bar")).sibling.text.must_equal("bar")
    end

    it "stores the given child" do
      Gutenberg::Node.new("foo", nil, nil, Gutenberg::Node.new("bar")).child.text.must_equal("bar")
    end

    it "defaults parent param to nil" do
      Gutenberg::Node.new("foo").parent.must_equal(nil)
    end

    it "defaults sibling param to nil" do
      Gutenberg::Node.new("foo").sibling.must_equal(nil)
    end

    it "defaults child param to nil" do
      Gutenberg::Node.new("foo").child.must_equal(nil)
    end
  end

  describe "#level" do
    before do
      # Set up a simple document tree
      level3_b = Gutenberg::Node.new "too", nil, nil, nil
      level3_a = Gutenberg::Node.new "soo", nil, level3_b, nil

      level2_b = Gutenberg::Node.new "meh", nil, nil, nil
      level2_a = Gutenberg::Node.new "bar", nil, level2_b, level3_a
      level3_a.parent = level2_a
      level3_b.parent = level2_a

      @root = Gutenberg::Node.new "foo", nil, nil, level2_a
      level2_a.parent = @root
      level2_b.parent = @root
    end

    it "handles the root as level 1" do
      @root.level.must_equal(1)
    end

    it "handles immediate children of the root as level 2" do
      @root.child.level.must_equal(2)
    end

    it "handles immediate grandchildren of the root as level 3" do
      @root.child.child.level.must_equal(3)
    end
  end

  describe "#slug" do
    it "should be a slug given the text of the node" do
      slug = stub(:normalize => "FOO")
      String.any_instance.expects(:to_slug).returns(slug)
      Gutenberg::Node.new("foo").slug.must_equal("FOO")
    end
  end
end
