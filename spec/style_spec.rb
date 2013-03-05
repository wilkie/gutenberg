require_relative 'helper'
require_relative '../lib/gutenberg/style.rb'

describe Gutenberg::Style do
  describe "#initialize" do
    before do
      YAML.stubs(:load_file).returns({})
      File.stubs(:exists?).returns(true)
    end

    it "should determine the path to the style" do
      Gutenberg::Style.new("foo").path.must_match /\/styles\/foo$/
    end

    it "should throw an error when the style does not exist" do
      File.stubs(:exists?).returns(false)
      proc {
        Gutenberg::Style.new("foo")
      }.must_raise Errno::ENOENT
    end

    it "should yield a reasonable default author when none is specified" do
      Gutenberg::Style.new("foo").author.must_equal "anonymous"
    end

    it "should yield a blank default description when none is specified" do
      Gutenberg::Style.new("foo").description.must_equal ""
    end

    it "should yield a default attribution of true when none is specified" do
      Gutenberg::Style.new("foo").attribute?.must_equal true
    end

    it "should yield an empty list of assets when none are specified" do
      Gutenberg::Style.new("foo").assets.must_equal []
    end

    it "read the author from the yaml file" do
      YAML.stubs(:load_file).returns({"author" => "wilkie"})
      Gutenberg::Style.new("foo").author.must_equal "wilkie"
    end

    it "read the attribution from the yaml file" do
      YAML.stubs(:load_file).returns({"attribution" => false})
      Gutenberg::Style.new("foo").attribute?.must_equal false
    end

    it "read the description from the yaml file" do
      YAML.stubs(:load_file).returns({"description" => "foo"})
      Gutenberg::Style.new("foo").description.must_equal "foo"
    end

    it "read the images map from the yaml file" do
      YAML.stubs(:load_file).returns({"images" => {"moo" => "moh"}})
      Gutenberg::Style.new("foo").image_for("moo").must_equal "style/moh"
    end

    it "read the assets from the yaml file" do
      YAML.stubs(:load_file).returns({"assets" => ["foo", "bar"]})
      Gutenberg::Asset.expects(:new).with("foo", anything).returns("a")
      Gutenberg::Asset.expects(:new).with("bar", anything).returns("b")
      Gutenberg::Style.new("foo").assets.must_equal ["a", "b"]
    end

    it "should yield the default author when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Style.new("foo").author.must_equal "anonymous"
    end

    it "should yield the default description when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Style.new("foo").description.must_equal ""
    end

    it "should yield the default attribution when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Style.new("foo").attribute?.must_equal true
    end

    it "should yield the default assets when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Style.new("foo").assets.must_equal []
    end

    it "should have option override the author when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Style.new("foo", :author => "wilkie").author.must_equal "wilkie"
    end

    it "should have option override the attribution when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Style.new("foo", :attribution => false).attribute?.must_equal false
    end

    it "should have option override the description when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Style.new("foo", :description => "moo").description.must_equal "moo"
    end

    it "should have option override the assets when not specified in the yaml" do
      YAML.stubs(:load_file).returns({})
      Gutenberg::Asset.expects(:new).with("moo", anything).returns("a")
      Gutenberg::Asset.expects(:new).with("boo", anything).returns("b")
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal ["a", "b"]
    end

    it "should have option override the author when specified in the yaml" do
      YAML.stubs(:load_file).returns({"author" => "finn"})
      Gutenberg::Style.new("foo", :author => "wilkie").author.must_equal "wilkie"
    end

    it "should have option override the attribution when specified in the yaml" do
      YAML.stubs(:load_file).returns({"attribution" => true})
      Gutenberg::Style.new("foo", :attribution => false).attribute?.must_equal false
    end

    it "should have option override the description when specified in the yaml" do
      YAML.stubs(:load_file).returns({"description" => "asdf"})
      Gutenberg::Style.new("foo", :description => "moo").description.must_equal "moo"
    end

    it "should have option override the assets when specified in the yaml" do
      YAML.stubs(:load_file).returns({"assets" => ["foo", "bar"]})
      Gutenberg::Asset.expects(:new).with("moo", anything).returns("a")
      Gutenberg::Asset.expects(:new).with("boo", anything).returns("b")
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal ["a", "b"]
    end

    it "should have option override the images when specified in the yaml" do
      YAML.stubs(:load_file).returns({"images" => {"asdf" => "foo"}})
      Gutenberg::Style.new("foo", :images => {"moo" => "moh", "boo" => "boh"})
        .image_for("moo").must_equal "style/moh"
    end

    it "should have option override the author when no yaml file" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)
      Gutenberg::Style.new("foo", :author => "wilkie").author.must_equal "wilkie"
    end

    it "should have option override the attribution when no yaml file" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)
      Gutenberg::Style.new("foo", :attribution => false).attribute?.must_equal false
    end

    it "should have option override the description when no yaml file" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)
      Gutenberg::Style.new("foo", :description => "moo").description.must_equal "moo"
    end

    it "should have option override the assets when no yaml file" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)
      Gutenberg::Asset.expects(:new).with("moo", anything).returns("a")
      Gutenberg::Asset.expects(:new).with("boo", anything).returns("b")
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal ["a", "b"]
    end

    it "should have option override the images when no yaml file" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)
      Gutenberg::Style.new("foo", :images => {"moo" => "moh", "boo" => "boh"})
        .image_for("moo").must_equal "style/moh"
    end

    it "should store the name given" do
      Gutenberg::Style.new("foo").name.must_equal "foo"
    end

    it "should pass the style path to Asset" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)
      Gutenberg::Asset.expects(:new).with("moo", regexp_matches(/styles\/foo$/)).returns("a")
      Gutenberg::Asset.expects(:new).with("boo", regexp_matches(/styles\/foo$/)).returns("b")
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal ["a", "b"]
    end
  end

  describe "#image_for" do
    before do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
    end

    it "returns nil when no image is tagged" do
      Gutenberg::Style.new("pretty", :images => {"foo" => "bar"})
        .image_for("moo").must_equal nil
    end

    it "returns the correct image when no image is tagged" do
      Gutenberg::Style.new("pretty", :images => {"foo" => "bar"})
        .image_for("foo").must_equal "style/bar"
    end
  end

  describe "#copy" do
    before do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
    end

    it "simply calls the copy method for each asset" do
      asset1 = mock('asset')
      asset2 = mock('asset')
      asset1.expects(:copy).with("style/output")
      asset2.expects(:copy).with("style/output")

      Gutenberg::Asset.stubs(:new).returns(asset1).then.returns(asset2)

      Gutenberg::Style.new("foo", :assets => ["moo", "boo"],
                                  :images => {"foo" => "bar"})
        .copy("output")
    end
  end
end
