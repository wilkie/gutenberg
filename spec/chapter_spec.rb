require_relative 'helper'
require_relative '../lib/gutenberg/chapter.rb'

describe Gutenberg::Chapter do
  it "can be created with no arguments" do
    Gutenberg::Chapter.new.must_be_instance_of Gutenberg::Chapter
  end

  it "can be created with passed in content" do
    Gutenberg::Chapter.new(:content => "foobar").content.must_equal("foobar")
  end

  it "can be created with a title" do
    Gutenberg::Chapter.new(:title => "Book Chapter").title.must_equal("Book Chapter")
  end

  it "can be created with an author" do
    Gutenberg::Chapter.new({:authors => ["wilkie"]})
      .authors.first.must_equal("wilkie")
  end

  it "can be created with a slug" do
    Gutenberg::Chapter.new({:slug => "my_slug"}).slug.must_equal("my_slug")
  end

  it "has an empty content by default" do
    Gutenberg::Chapter.new.content.must_equal("")
  end

  it "has a reasonable default title" do
    Gutenberg::Chapter.new.title.must_equal("Untitled")
  end

  it "has an empty list of authors by default" do
    Gutenberg::Chapter.new.authors.must_equal([])
  end

  it "has a general slug by default" do
    Gutenberg::Chapter.new.slug.must_equal("chapter")
  end

  describe "when passed a markdown file" do
    before do
      # mock out a renderer that, by default, renders any markdown as <foo>
      @renderer = mock('renderer')
      @renderer.stubs(:render).returns("<foo>")
      Redcarpet::Markdown.stubs(:new).returns(@renderer)

      # any file reads will give you a blank string
      File.stubs(:read).returns("")

      # default to yaml not parsing anything
      YAML.stubs(:load).returns({})
    end

    it "generates a slug based on the filename of the markdown" do
      Gutenberg::Chapter.new(:markdown_file => "foo.md").slug.must_equal("foo")
    end

    it "generates html from markdown" do
      Gutenberg::Chapter.new(:markdown_file => "foo.md").html.must_equal("<foo>")
    end

    it "exposes markdown content" do
      File.stubs(:read).returns("blah")
      Gutenberg::Chapter.new(:markdown_file => "foo.md").content.must_equal("blah")
    end

    it "captures yaml inside markdown content" do
      File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
      YAML.expects(:load).with("title: foo").returns({"title" => "foo"})
      Gutenberg::Chapter.new(:markdown_file => "foo.md")
    end

    it "reads title from yaml inside markdown content" do
      File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
      YAML.stubs(:load).with("title: foo").returns({"title" => "foo"})
      Gutenberg::Chapter.new(:markdown_file => "foo.md").title.must_equal("foo")
    end

    it "reads authors from yaml inside markdown content" do
      File.stubs(:read).returns("---\nauthors: ['foo']\n---\nblah")
      YAML.stubs(:load).with("authors: ['foo']").returns({"authors" => ["foo"]})
      Gutenberg::Chapter.new(:markdown_file => "foo.md")
        .authors.must_equal(["foo"])
    end

    it "removes yaml information in exposed content" do
      File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
      Gutenberg::Chapter.new(:markdown_file => "foo.md").content.must_equal("blah")
    end

    it "infers the title from the markdown" do
      File.stubs(:read).returns("---\nauthors: ['foo']\n---\nblah")
      Gutenberg::MarkdownRenderer.any_instance.expects(:title).returns("hello")
      Gutenberg::Chapter.new(:markdown_file => "foo.md").title.must_equal("hello")
    end

    it "can override the title in the yaml" do
      File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
      YAML.stubs(:load).with("title: foo").returns({"title" => "foo"})
      Gutenberg::Chapter.new(:markdown_file => "foo.md",
                             :title => "moo").title.must_equal("moo")
    end

    it "can override the title inferred by the markdown with yaml" do
      File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
      YAML.stubs(:load).with("title: foo").returns({"title" => "foo"})
      Gutenberg::MarkdownRenderer.any_instance.stubs(:title).returns("hello")
      Gutenberg::Chapter.new(:markdown_file => "foo.md").title.must_equal("foo")
    end

    it "can override the title inferred by the markdown with parameter" do
      File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
      YAML.stubs(:load).with("title: foo").returns({"title" => "foo"})
      Gutenberg::MarkdownRenderer.any_instance.stubs(:title).returns("hello")
      Gutenberg::Chapter.new(:markdown_file => "foo.md",
                             :title => "moo").title.must_equal("moo")
    end

    it "parses the remaining content as markdown after the yaml" do
      File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
      @renderer.expects(:render).with("blah")
      Gutenberg::Chapter.new(:markdown_file => "foo.md")
    end
  end
end

