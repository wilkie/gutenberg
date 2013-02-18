require_relative 'helper'
require_relative '../lib/gutenberg/asset.rb'

describe Gutenberg::Asset do
  describe "path" do
    it "should return the path within the gem" do
      File.expand_path(Gutenberg::Asset.path).must_equal(
        File.expand_path("#{File.dirname(__FILE__)}/../lib/gutenberg/assets"))
    end
  end

  describe "#initialize" do
    it "should determine the absolute path of the style-supplied asset" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("foobar/images/foo.png").returns(true)
      Gutenberg::Asset.new("images/foo.png", "foobar").path.must_equal(
        File.expand_path(
          "#{File.dirname(__FILE__)}/../foobar/images/foo.png"))
    end

    it "should determine the absolute path of the gem-supplied asset" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("#{Gutenberg::Asset.path}/images/foo.png").returns(true)
      Gutenberg::Asset.new("images/foo.png").path.must_equal(
        File.expand_path(
          "#{File.dirname(__FILE__)}/../lib/gutenberg/assets/images/foo.png"))
    end

    it "should determine the absolute path of the local-supplied asset" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      asset = Gutenberg::Asset.new "images/foo.png"
      asset.path.must_equal(
        File.expand_path(
          "#{File.dirname(__FILE__)}/../images/foo.png"))
    end

    it "should determine the absolute path of the local-supplied asset" do
      File.stubs(:exists?).returns(false)
      proc {
        Gutenberg::Asset.new("images/foo.png")
      }.must_raise Errno::ENOENT
    end

    it "should load the associated metadata file" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      File.expects(:exists?).with(
        File.expand_path( "#{File.dirname(__FILE__)}/../images/foo.yml"))
        .returns(true)
      YAML.expects(:load_file).returns({})
      Gutenberg::Asset.new("images/foo.png")
    end

    it "does not attempt to load a metadata file if it does not exist" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      YAML.expects(:load_file).never
      Gutenberg::Asset.new("images/foo.png")
    end

    it "pulls author out of yaml info when it exists" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({"author" => "wilkie"})
      Gutenberg::Asset.new("images/foo.png").author.must_equal "wilkie"
    end

    it "pulls author_url out of yaml info when it exists" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({"author-website" => "foo"})
      Gutenberg::Asset.new("images/foo.png").author_url.must_equal "foo"
    end

    it "pulls collection out of yaml info when it exists" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({"collection" => "foo"})
      Gutenberg::Asset.new("images/foo.png").collection.must_equal "foo"
    end

    it "pulls collection_url out of yaml info when it exists" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({"collection-website" => "foo"})
      Gutenberg::Asset.new("images/foo.png").collection_url.must_equal "foo"
    end

    it "pulls name out of yaml info when it exists" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({"name" => "foo"})
      Gutenberg::Asset.new("images/foo.png").name.must_equal "foo"
    end

    it "defaults author to nil when yaml does not exist" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      Gutenberg::Asset.new("images/foo.png").author.must_equal nil
    end

    it "defaults author_url to nil when yaml does not exist" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      Gutenberg::Asset.new("images/foo.png").author_url.must_equal nil
    end

    it "defaults collection to nil when yaml does not exist" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      Gutenberg::Asset.new("images/foo.png").collection.must_equal nil
    end

    it "defaults collection_url to nil when yaml does not exist" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      Gutenberg::Asset.new("images/foo.png").collection_url.must_equal nil
    end

    it "defaults name to nil when yaml does not exist" do
      File.stubs(:exists?).returns(false)
      File.stubs(:exists?).with("images/foo.png").returns(true)
      Gutenberg::Asset.new("images/foo.png").name.must_equal nil
    end

    it "defaults author to nil when not defined in the yaml" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
      Gutenberg::Asset.new("images/foo.png").author.must_equal nil
    end

    it "defaults author_url to nil when not defined in the yaml" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
      Gutenberg::Asset.new("images/foo.png").author_url.must_equal nil
    end

    it "defaults collection to nil when not defined in the yaml" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
      Gutenberg::Asset.new("images/foo.png").collection.must_equal nil
    end

    it "defaults collection_url to nil when not defined in the yaml" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
      Gutenberg::Asset.new("images/foo.png").collection_url.must_equal nil
    end

    it "defaults name to nil when not defined in the yaml" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})
      Gutenberg::Asset.new("images/foo.png").name.must_equal nil
    end
  end

  describe "#copy" do
    it "creates the correct directory for the asset" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})

      FileUtils.stubs(:cp)
      FileUtils.expects(:mkdir_p).with(regexp_matches(/bar\/images$/))
      Gutenberg::Asset.new("images/foo.png").copy "bar"
    end

    it "copies to the created asset directory" do
      File.stubs(:exists?).returns(true)
      YAML.stubs(:load_file).returns({})

      FileUtils.stubs(:mkdir_p)
      FileUtils.expects(:cp).with(regexp_matches(/images\/foo.png$/), regexp_matches(/bar\/images/))

      Gutenberg::Asset.new("images/foo.png").copy "bar"
    end
  end
end
