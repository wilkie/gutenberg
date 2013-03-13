require_relative 'helper'
require_relative '../lib/gutenberg/book.rb'

describe Gutenberg::Book do
  before do
    Gutenberg::Style.stubs(:new).returns(mock('style'))
    @chapter = mock('chapter')
    @chapter.stubs(:images).returns([])
    @chapter.stubs(:tables).returns([])
  end

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
    Gutenberg::Style.expects(:new).with("really_pretty", anything).returns("foo")
    Gutenberg::Book.new({:style => "really_pretty"}).style.must_equal("foo")
  end

  it "can be created with style config" do
    Gutenberg::Style.expects(:new).with("basic", has_entry(:yaml, "foo_config")).returns("foo")
    Gutenberg::Book.new({:style_config => "foo_config"})
  end

  it "can be created with a table of contents flag" do
    Gutenberg::Book.new({:toc => true})
      .toc.must_equal(true)
  end

  it "can be created with a title" do
    Gutenberg::Book.new({:cover => "cover.svg"}).cover.must_equal("cover.svg")
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
    Gutenberg::Style.expects(:new).with("pretty", anything).returns("foo")
    Gutenberg::Book.new({:yaml => 'test.yaml'}).style.must_equal("foo")
  end

  it "style config file can be pulled from yaml" do
    YAML.stubs(:load_file).returns({"style-config" => "foo_config"})
    Gutenberg::Style.expects(:new).with("basic", has_entry(:yaml, "foo_config")).returns("foo")
    Gutenberg::Book.new({:yaml => 'test.yaml'}).style.must_equal("foo")
  end

  it "toc can be pulled from yaml" do
    YAML.stubs(:load_file).returns({"toc" => true})
    Gutenberg::Book.new({:yaml => 'test.yaml'}).toc.must_equal(true)
  end

  it "pulls chapters from yaml" do
    YAML.stubs(:load_file).returns({"chapters" => ["foo"]})
    Gutenberg::Chapter.expects(:new).with(has_entry(:markdown_file, "foo")).returns(@chapter)
    Gutenberg::Book.new({:yaml => "test.yaml"}).chapters.must_equal([@chapter])
  end

  it "pulls prefaces from yaml" do
    YAML.stubs(:load_file).returns({"prefaces" => ["foo"]})
    Gutenberg::Chapter.expects(:new).with(has_entry(:markdown_file, "foo")).returns(@chapter)
    Gutenberg::Book.new({:yaml => "test.yaml"}).prefaces.must_equal([@chapter])
  end

  it "cover can be pulled from yaml" do
    YAML.stubs(:load_file).returns({"cover" => "cover.svg"})
    Gutenberg::Book.new({:yaml => 'test.yaml'}).cover.must_equal("cover.svg")
  end

  it "has a reasonable default title" do
    Gutenberg::Book.new.title.must_equal("Untitled")
  end

  it "has a reasonable default list of authors" do
    Gutenberg::Book.new.authors.must_equal(["anonymous"])
  end

  it "has a reasonable default style" do
    Gutenberg::Style.expects(:new).with("basic", anything).returns("foo")
    Gutenberg::Book.new.style.must_equal("foo")
  end

  it "has a reasonable default style config file" do
    Gutenberg::Style.expects(:new).with("basic", has_entry(:yaml, "style.yml"))
    Gutenberg::Book.new
  end

  it "has a default of false for toc" do
    Gutenberg::Book.new.toc.must_equal(false)
  end

  it "has an empty list of chapters by default" do
    Gutenberg::Book.new.chapters.must_equal([])
  end

  it "has an empty list of prefaces by default" do
    Gutenberg::Book.new.prefaces.must_equal([])
  end

  it "has nil cover by default" do
    Gutenberg::Book.new.cover.must_equal(nil)
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
    Gutenberg::Style.expects(:new).with("basic", anything).returns("foo")
    Gutenberg::Book.new({:yaml => "test.yaml"}).style.must_equal("foo")
  end

  it "has a reasonable default style config when not specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Style.expects(:new).with("basic", has_entry(:yaml, "style.yml"))
    Gutenberg::Book.new({:yaml => "test.yaml"})
  end

  it "has a default of false for toc when not specified in the yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).toc.must_equal(false)
  end

  it "has an empty list of chapters by default when not specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).chapters.must_equal([])
  end

  it "has an empty list of prefaces by default when not specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).prefaces.must_equal([])
  end

  it "has nil cover by default when not specified in yaml" do
    YAML.stubs(:load_file).returns({"title" => "foo"})
    Gutenberg::Book.new({:yaml => "test.yaml"}).cover.must_equal(nil)
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
    YAML.stubs(:load_file).returns({"style" => "moo"})
    Gutenberg::Style.expects(:new).with("bar", anything).returns("foo")
    Gutenberg::Book.new({:yaml => "test.yaml", :style => "bar"}).style.must_equal("foo")
  end

  it "can override the style config that is specified in yaml" do
    YAML.stubs(:load_file).returns({"style-config" => "moo_config"})
    Gutenberg::Style.expects(:new).with("bar", has_entry(:yaml, "bar_config"))
    Gutenberg::Book.new({:yaml => "test.yaml", :style => "bar", :style_config => "bar_config"})
  end

  it "can override the toc setting that is specified in yaml" do
    YAML.stubs(:load_file).returns({"toc" => false})
    Gutenberg::Book.new({:yaml => "test.yaml", :toc => true}).toc.must_equal(true)
  end

  it "can override the chapters that are specified in yaml" do
    YAML.stubs(:load_file).returns({"chapters" => ["foo"]})
    Gutenberg::Chapter.expects(:new).with(has_entry(:markdown_file, "bar")).returns(@chapter)
    Gutenberg::Book.new({:yaml => "test.yaml", :chapters => ["bar"]}).chapters.must_equal([@chapter])
  end

  it "can override the prefaces that are specified in yaml" do
    YAML.stubs(:load_file).returns({"prefaces" => ["foo"]})
    Gutenberg::Chapter.expects(:new).with(has_entry(:markdown_file, "bar")).returns(@chapter)
    Gutenberg::Book.new({:yaml => "test.yaml", :prefaces => ["bar"]}).prefaces.must_equal([@chapter])
  end

  it "can override the cover that is specified in yaml" do
    YAML.stubs(:load_file).returns({"cover" => "cover.svg"})
    Gutenberg::Book.new({:yaml => "test.yaml", :cover => "bar.svg"}).cover.must_equal("bar.svg")
  end

  it "creates a Chapter object for a listed chapter" do
    c = Gutenberg::Chapter.new
    Gutenberg::Chapter.expects(:new).with(has_entry(:markdown_file, "foo")).returns(c)
    Gutenberg::Book.new({:chapters => ["foo"]})
      .chapters.first.must_be_instance_of(Gutenberg::Chapter)
  end

  it "passes the style to the Chapter objects" do
    Gutenberg::Chapter.expects(:new).with(has_entry(:style, "foo")).returns(@chapter)
    Gutenberg::Style.stubs(:new).returns("foo")
    Gutenberg::Book.new(:chapters => ["foo"], :style => "pretty")
  end

  it "combines all images from all chapters into images property" do
    chapter_1 = mock('chapter')
    chapter_2 = mock('chapter')
    chapter_1.expects(:images).returns(["foo", "bar"])
    chapter_2.expects(:images).returns(["baz", "caz"])
    chapter_1.stubs(:tables).returns([])
    chapter_2.stubs(:tables).returns([])
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "foo")).returns(chapter_1)
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "boo")).returns(chapter_2)
    Gutenberg::Book.new({:chapters => ["foo", "boo"]})
      .images.must_equal ["foo", "bar", "baz", "caz"]
  end

  it "combines all tables from all chapters into tables property" do
    chapter_1 = mock('chapter')
    chapter_2 = mock('chapter')
    chapter_1.stubs(:images).returns([])
    chapter_2.stubs(:images).returns([])
    chapter_1.expects(:tables).returns(["foo", "bar"])
    chapter_2.expects(:tables).returns(["baz", "caz"])
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "foo")).returns(chapter_1)
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "boo")).returns(chapter_2)
    Gutenberg::Book.new({:chapters => ["foo", "boo"]})
      .tables.must_equal ["foo", "bar", "baz", "caz"]
  end

  it "can override the prefaces that are specified in yaml" do
    YAML.stubs(:load_file).returns({"prefaces" => ["foo"]})
    Gutenberg::Chapter.expects(:new).with(has_entry(:markdown_file, "bar")).returns(@chapter)
    Gutenberg::Book.new({:yaml => "test.yaml", :prefaces => ["bar"]}).prefaces.must_equal([@chapter])
  end

  it "creates a Chapter object for a listed preface" do
    c = Gutenberg::Chapter.new
    Gutenberg::Chapter.expects(:new).with(has_entry(:markdown_file, "foo")).returns(c)
    Gutenberg::Book.new({:prefaces => ["foo"]})
      .prefaces.first.must_be_instance_of(Gutenberg::Chapter)
  end

  it "passes the style to the Chapter objects created for prefaces" do
    Gutenberg::Chapter.expects(:new).with(has_entry(:style, "foo")).returns(@chapter)
    Gutenberg::Style.stubs(:new).returns("foo")
    Gutenberg::Book.new(:prefaces => ["foo"], :style => "pretty")
  end

  it "combines all images from all prefaces into images property" do
    chapter_1 = mock('chapter')
    chapter_2 = mock('chapter')
    chapter_1.expects(:images).returns(["foo", "bar"])
    chapter_2.expects(:images).returns(["baz", "caz"])
    chapter_1.stubs(:tables).returns([])
    chapter_2.stubs(:tables).returns([])
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "foo")).returns(chapter_1)
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "boo")).returns(chapter_2)
    Gutenberg::Book.new({:prefaces => ["foo", "boo"]})
      .images.must_equal ["foo", "bar", "baz", "caz"]
  end

  it "combines all tables from all prefaces into tables property" do
    chapter_1 = mock('chapter')
    chapter_2 = mock('chapter')
    chapter_1.stubs(:images).returns([])
    chapter_2.stubs(:images).returns([])
    chapter_1.expects(:tables).returns(["foo", "bar"])
    chapter_2.expects(:tables).returns(["baz", "caz"])
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "foo")).returns(chapter_1)
    Gutenberg::Chapter.stubs(:new).with(has_entry(:markdown_file, "boo")).returns(chapter_2)
    Gutenberg::Book.new({:prefaces => ["foo", "boo"]})
      .tables.must_equal ["foo", "bar", "baz", "caz"]
  end
end
