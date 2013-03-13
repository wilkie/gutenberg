require_relative 'helper'
require_relative '../lib/gutenberg/style.rb'

describe Gutenberg::Style do
  describe "#initialize" do
    before do
      YAML.stubs(:load_file).returns({})
      File.stubs(:exists?).returns(true)
      @asset = mock('asset')
      @asset.stubs(:type).returns(:image)
    end

    describe "when local style config is provided" do
      it "should load external assets" do
        YAML.stubs(:load_file).with("style.yml").returns({"assets"=>["foo", "bar"]})
        Gutenberg::Asset.stubs(:new).returns(@asset)
        Gutenberg::Style.new("foo", :yaml => "style.yml").external_assets.length.must_equal 2
      end

      it "should load assets as not style supplied" do
        YAML.stubs(:load_file).with("style.yml").returns({"assets"=>["foo", "bar"]})
        Gutenberg::Asset.expects(:new).with(anything).returns(@asset).twice
        Gutenberg::Style.new("foo", :yaml => "style.yml")
      end

      it "should add images to images property" do
        YAML.stubs(:load_file).with("style.yml").returns({"assets"=>["foo", "bar"]})
        @asset.stubs(:type).returns(:image)
        Gutenberg::Asset.stubs(:new).with(anything).returns(@asset).twice
        Gutenberg::Style.new("foo", :yaml => "style.yml").images.must_include @asset
      end

      it "should add stylesheets to stylesheets property" do
        YAML.stubs(:load_file).with("style.yml").returns({"assets"=>["foo", "bar"]})
        @asset.stubs(:type).returns(:stylesheet)
        Gutenberg::Asset.stubs(:new).with(anything).returns(@asset).twice
        Gutenberg::Style.new("foo", :yaml => "style.yml").stylesheets.must_include @asset
      end

      it "should add scripts to scripts property" do
        YAML.stubs(:load_file).with("style.yml").returns({"assets"=>["foo", "bar"]})
        @asset.stubs(:type).returns(:script)
        Gutenberg::Asset.stubs(:new).with(anything).returns(@asset).twice
        Gutenberg::Style.new("foo", :yaml => "style.yml").scripts.must_include @asset
      end
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
      asset1 = mock('asset')
      asset1.stubs(:type).returns(:image)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:image)
      Gutenberg::Asset.expects(:new).with("foo", anything).returns(asset1)
      Gutenberg::Asset.expects(:new).with("bar", anything).returns(asset2)
      Gutenberg::Style.new("foo").assets.must_equal [asset1, asset2]
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
      asset1 = mock('asset')
      asset1.stubs(:type).returns(:image)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:image)
      Gutenberg::Asset.expects(:new).with("moo", anything).returns(asset1)
      Gutenberg::Asset.expects(:new).with("boo", anything).returns(asset2)
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal [asset1, asset2]
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
      asset1 = mock('asset')
      asset1.stubs(:type).returns(:image)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:image)
      Gutenberg::Asset.expects(:new).with("moo", anything).returns(asset1)
      Gutenberg::Asset.expects(:new).with("boo", anything).returns(asset2)
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal [asset1, asset2]
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
      asset1 = mock('asset')
      asset1.stubs(:type).returns(:image)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:image)
      Gutenberg::Asset.expects(:new).with("moo", anything).returns(asset1)
      Gutenberg::Asset.expects(:new).with("boo", anything).returns(asset2)
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal [asset1, asset2]
    end

    it "should have option override the images when no yaml file" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)
      Gutenberg::Style.new("foo", :images => {"moo" => "moh", "boo" => "boh"})
        .image_for("moo").must_equal "style/moh"
    end

    it "should store the name given" do
      Gutenberg::Style.new("foo").name.must_equal "foo"
    end

    it "should pass the style to Asset" do
      File.stubs(:exists?).with(regexp_matches(/\.yml$/)).returns(false)

      asset1 = mock('asset')
      asset1.stubs(:type).returns(:image)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:image)

      Gutenberg::Asset.expects(:new).with("moo", instance_of(Gutenberg::Style)).returns(asset1)
      Gutenberg::Asset.expects(:new).with("boo", instance_of(Gutenberg::Style)).returns(asset2)
      Gutenberg::Style.new("foo", :assets => ["moo", "boo"]).assets.must_equal [asset1, asset2]
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
      asset1.stubs(:type).returns(:image)
      asset2.expects(:copy).with("style/output")
      asset2.stubs(:type).returns(:image)

      Gutenberg::Asset.stubs(:new).returns(asset1).then.returns(asset2)

      Gutenberg::Style.new("foo", :assets => ["moo", "boo"],
                                  :images => {"foo" => "bar"})
        .copy("output")
    end
  end

  describe "#stylesheets" do
    before do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
    end

    it "should collect all stylesheet assets" do
      YAML.stubs(:load_file).returns({"assets" => ["foo", "bar", "baz"]})
      asset1 = mock('asset')
      asset1.stubs(:type).returns(:image)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:stylesheet)
      asset3 = mock('asset')
      asset3.stubs(:type).returns(:stylesheet)
      Gutenberg::Asset.stubs(:new).with("foo", anything, anything).returns(asset1)
      Gutenberg::Asset.stubs(:new).with("bar", anything, anything).returns(asset2)
      Gutenberg::Asset.stubs(:new).with("baz", anything, anything).returns(asset3)
      Gutenberg::Style.new("foo").stylesheets.must_equal [asset2, asset3]
    end
  end

  describe "#images" do
    before do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
    end

    it "should collect all image assets" do
      YAML.stubs(:load_file).returns({"assets" => ["foo", "bar", "baz"]})
      asset1 = mock('asset')
      asset1.stubs(:type).returns(:image)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:stylesheet)
      asset3 = mock('asset')
      asset3.stubs(:type).returns(:image)
      Gutenberg::Asset.stubs(:new).with("foo", anything).returns(asset1)
      Gutenberg::Asset.stubs(:new).with("bar", anything).returns(asset2)
      Gutenberg::Asset.stubs(:new).with("baz", anything).returns(asset3)
      Gutenberg::Style.new("foo").images.must_equal [asset1, asset3]
    end
  end

  describe "#scripts" do
    before do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
    end

    it "should collect all script assets" do
      YAML.stubs(:load_file).returns({"assets" => ["foo", "bar", "baz"]})
      asset1 = mock('asset')
      asset1.stubs(:type).returns(:script)
      asset2 = mock('asset')
      asset2.stubs(:type).returns(:script)
      asset3 = mock('asset')
      asset3.stubs(:type).returns(:image)
      Gutenberg::Asset.stubs(:new).with("foo", anything).returns(asset1)
      Gutenberg::Asset.stubs(:new).with("bar", anything).returns(asset2)
      Gutenberg::Asset.stubs(:new).with("baz", anything).returns(asset3)
      Gutenberg::Style.new("foo").scripts.must_equal [asset1, asset2]
    end
  end
end
