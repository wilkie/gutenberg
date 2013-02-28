require_relative 'helper'
require_relative '../lib/gutenberg/chapter.rb'

describe Gutenberg::Chapter do
  describe "#initialize" do
    it "can be created with no arguments" do
      Gutenberg::Chapter.new.must_be_instance_of Gutenberg::Chapter
    end

    it "can be created with passed in content" do
      Gutenberg::Chapter.new(:content => "foobar").content.must_equal("foobar")
    end

    it "can be created with a title" do
      Gutenberg::Chapter.new(:title => "Book Chapter").title.must_equal("Book Chapter")
    end

    it "can be created with an index" do
      Gutenberg::Chapter.new(:index => "V").index.must_equal("V")
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
        @md_renderer = mock('md_renderer')
        @md_renderer.stubs(:title).returns("")
        @md_renderer.stubs(:outline).returns(nil)
        Gutenberg::MarkdownRenderer.stubs(:new).returns(@md_renderer)

        @renderer = mock('renderer')
        @renderer.stubs(:render).returns("<foo>")
        Redcarpet::Markdown.stubs(:new).returns(@renderer)

        # any file reads will give you a blank string
        File.stubs(:read).returns("")

        # default to yaml not parsing anything
        YAML.stubs(:load).returns({})
      end

      it "makes use of the custom renderer" do
        Gutenberg::MarkdownRenderer.expects(:new).returns(@md_renderer)
        Gutenberg::Chapter.new(:markdown_file => "foo.md")
      end

      it "passes the custom renderer a slug and a language as strings" do
        Gutenberg::MarkdownRenderer.expects(:new)
          .with(instance_of(String), anything, instance_of(String), anything, instance_of(String)).returns(@md_renderer)
        Gutenberg::Chapter.new(:markdown_file => "foo.md")
      end

      it "passes the style to the custom renderer" do
        Gutenberg::MarkdownRenderer.expects(:new)
          .with(anything, anything, anything, "foo", "").returns(@md_renderer)
        Gutenberg::Chapter.new(:markdown_file => "foo.md", :style => "foo")
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
        md_renderer = mock('md_renderer')
        md_renderer.stubs(:title).returns("hello")
        md_renderer.stubs(:outline).returns(nil)
        Gutenberg::MarkdownRenderer.stubs(:new).returns(md_renderer)
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

      it "can not override index in the yaml" do
        File.stubs(:read).returns("---\nindex: R\n---\nblah")
        YAML.stubs(:load).with("index: R").returns({"index" => "R"})
        Gutenberg::Chapter.new(:markdown_file => "foo.md",
                               :index => "V").index.must_equal("R")
      end

      it "can provide index in the yaml" do
        File.stubs(:read).returns("---\nindex: R\n---\nblah")
        YAML.stubs(:load).with("index: R").returns({"index" => "R"})
        Gutenberg::Chapter.new(:markdown_file => "foo.md").index.must_equal("R")
      end

      it "parses the remaining content as markdown after the yaml" do
        File.stubs(:read).returns("---\ntitle: foo\n---\nblah")
        @renderer.expects(:render).with("blah")
        Gutenberg::Chapter.new(:markdown_file => "foo.md")
      end
    end
  end
end

