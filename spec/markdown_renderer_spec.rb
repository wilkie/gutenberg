require_relative 'helper'
require_relative '../lib/gutenberg/markdown_renderer.rb'

describe Gutenberg::MarkdownRenderer do
  before do
    @style = mock('style')
    @style.stubs(:image_for).returns("image")
    @hyphen = mock('hyphen')
    Text::Hyphen.stubs(:new).returns(@hyphen)
    @renderer = Gutenberg::MarkdownRenderer.new("slug", "Foo", "en_us", @style, "")
  end

  describe "#title" do
    it "parses out the title as the first header" do
      @renderer.header(" hello ", 1)
      @renderer.header(" foo ", 2)
      @renderer.title.must_equal("hello")
    end
  end

  describe "#paragraph" do
    it "runs text through text-hyphen" do
      @hyphen.expects(:visualize).with("hello", "&shy;")
      @renderer.paragraph("hello")
    end

    it "does not run @[] blocks through text-hyphen" do
      @hyphen.expects(:visualize).with("hello", "&shy;").never
      @renderer.paragraph("@[hello]")
    end

    it "runs text through text-hyphen when paragraph starts with !" do
      @hyphen.expects(:visualize).with("hello", "&shy;")
      @renderer.paragraph("!note hello")
    end

    it "generates a p tag" do
      @hyphen.stubs(:visualize).returns("hello")
      @renderer.paragraph("hello").must_match /<p[^>]*>hello<\/p>/
    end

    it "generates a div tag when paragraph starts with !" do
      @hyphen.stubs(:visualize).returns("hello")
      @renderer.paragraph("!note hello")
        .must_match /<div.*?class=['"]inset note['"][^>]*><img.*?><p[^>]*>hello<\/p><\/div>/
    end

    it "discovers the image from the style class" do
      @hyphen.stubs(:visualize).returns("hello")
      @style.expects(:image_for).with('note').returns("foo")
      @renderer.paragraph("!note hello")
        .must_match /<img.*?src=['"]foo['"]\s*\/>/
    end
  end

  describe "#block_quote" do
    it "generates a blockquote tag" do
      @renderer.block_quote("hello").must_match /<blockquote[^>]*><img.*?><p>hello<\/p><\/blockquote>/
    end

    it "generates a div and cite inside the blockquote tag when citation is found" do
      @renderer.block_quote("hello -- foo bar")
        .must_match /<blockquote[^>]*><img.*?><p>hello<\/p><div><cite>foo bar<\/cite><\/div><\/blockquote>/
    end

    it "discovers the image from the style class" do
      @hyphen.stubs(:visualize).returns("hello")
      @style.expects(:image_for).with('quote').returns("foo")
      @renderer.block_quote("hello")
        .must_match /<img.*?src=['"]foo['"]\s*\/>/
    end

    it "discovers the image from the style class when citation is found" do
      @hyphen.stubs(:visualize).returns("hello -- foo bar")
      @style.expects(:image_for).with('quote').returns("foo")
      @renderer.block_quote("hello")
        .must_match /<img.*?src=['"]foo['"]\s*\/>/
    end
  end

  describe "#outline" do
    it "returns a default node for the content with the given name" do
      @renderer.outline.text = "Slug"
    end

    it "returns a default node for the content when not given a name" do
      renderer = Gutenberg::MarkdownRenderer.new("slug", nil, "en_us", @style, "")
      renderer.outline.text = "Untitled"
    end

    it "returns a root node containing the first header text" do
      @renderer.header("Foo", 1)
      @renderer.outline.text = "Foo"
    end

    it "returns a root node that has no parent" do
      @renderer.header("Foo", 1)
      @renderer.outline.parent = nil
    end

    it "returns children nodes for each subheader" do
      @renderer.header("Foo", 1)
      @renderer.header("Bar", 2)
      @renderer.header("Baz", 3)
      @renderer.header("Bat", 3)
      @renderer.header("Moo", 2)
      @renderer.outline.child.text.must_equal "Bar"
      @renderer.outline.child.sibling.text.must_equal "Moo"
    end

    it "returns grand-children nodes for subsubheaders" do
      @renderer.header("Foo", 1)
      @renderer.header("Bar", 2)
      @renderer.header("Baz", 3)
      @renderer.header("Bat", 3)
      @renderer.header("Moo", 2)
      @renderer.outline.child.child.text.must_equal "Baz"
      @renderer.outline.child.child.sibling.text.must_equal "Bat"
    end
  end

  describe "#header" do
    it "generates a header tag of the specified header level" do
      @renderer.header("foo", 3).must_match /^<h3/
    end

    it "generates a header with the id matching a slug based on the header text" do
      @renderer.header("foo", 2).must_match /^<h2\s.*id=['"]foo['"]/
    end

    it "generates a header with the given text" do
      @renderer.header("foo", 1).must_match /^<h1\s.*?>foo<\/h1>$/
    end

    it "generates a closing tag that matches the opening tag" do
      @renderer.header("foo", 2).must_match /^<h(\d).*?>.*<\/h\1>$/
    end
  end

  describe "#codespace" do
    it "generates a code section" do
      @renderer.codespan("foo").must_match /^<code>foo<\/code>$/
    end

    it "replaces hyphens with non-breaking hyphens" do
      @renderer.codespan("foo-bar").must_match /foo&#8209;bar/
    end
  end

  describe "#block_code" do
    it "generates a pre section" do
      @renderer.block_code("foo", "").must_match /<pre[^>]*>.*?<\/pre>/
    end

    it "generates a code section inside a pre section" do
      @renderer.block_code("foo", "").must_match /<pre[^>]*>[^<]*<code[ >].*?<\/code>[^<]*?<\/pre>/
    end

    # TODO: code section lines (after I can see them rendered)
  end

  describe "#image" do
    it "generates the img tag within a figure tag" do
      @renderer.image("link", "title", "alt_text").must_match /<figure\s.*class=['"]image['"][^>]*><img\s.*src=['"]link['"][ >]/
    end

    it "generates the img tag with an id containing slug" do
      @renderer.image("link", "title", "alt_text").must_match /<figure[^>]*?id=['"]figure-slug-1['"]/
    end

    it "generates a img tag with the link as the src" do
      @renderer.image("link", "title", "alt_text").must_match /<img\s.*src=['"]link['"][ >]/
    end

    it "generates a img tag with the link as the src and ignores the reference tag" do
      @renderer.image("tag@link", "title", "alt_text").must_match /<img\s.*src=['"]link['"][ >]/
    end

    it "generates a img tag with the alt given as an attribute" do
      @renderer.image("link", "title", "alt_text").must_match /<img\s.*alt=['"]alt_text['"][ >]/
    end

    it "generates a img tag with the title given as an attribute" do
      @renderer.image("link", "title", "alt_text").must_match /<img\s.*title=['"]title['"][ >]/
    end

    it "generates a img tag with the title given as an attribute" do
      @renderer.image("link", "title", "alt_text").must_match /<img\s.*title=['"]title['"][ >]/
    end

    it "generates a caption div when a title is given" do
      @renderer.image("link", "title", "alt_text").must_match /<figcaption><strong>Figure 1<\/strong>: title</
    end

    it "generates a caption div with the chapter index when one is provided" do
      renderer = Gutenberg::MarkdownRenderer.new("slug", "Foo", "en_us", @style, "V")
      renderer.image("link", "title", "alt_text").must_match /<figcaption><strong>Figure V-1<\/strong>: title</
    end

    it "does not generate a caption div when a title is not given" do
      @renderer.image("link", "", "alt_text").wont_match /<figcaption>/
    end

    describe "when given a youtube link" do
      it "generates an iframe" do
        @renderer.image("http://www.youtube.com/watch?v=fzlHs0UNmDY",
                        "title", "alt_text").must_match /<iframe/
      end

      it "generates an iframe with the youtube_frame class" do
        @renderer.image("http://www.youtube.com/watch?v=fzlHs0UNmDY",
                        "title", "alt_text").must_match /<iframe\s[^>]*?class=['"]youtube_frame['"]/
      end

      it "generates an iframe with the given alt text used when iframes not supported for accessibility" do
        @renderer.image("http://www.youtube.com/watch?v=fzlHs0UNmDY",
                        "title", "alt_text").must_match /<iframe[^>]*?>alt_text<\/iframe/
      end

      it "generates a caption div when a title is given" do
        @renderer.image("http://www.youtube.com/watch?v=fzlHs0UNmDY",
                        "title", "alt_text").must_match /<figcaption><strong>Figure 1<\/strong>: title</
      end

      it "does not generate a caption div when a title is not given" do
        @renderer.image("http://www.youtube.com/watch?v=fzlHs0UNmDY",
                        "", "alt_text").wont_match /<figcaption>/
      end
    end
  end

  describe "#lookup" do
    it "uses the tag for an image link as a reference" do
      @renderer.image("tag@link", "", "alt_text")
      @renderer.lookup("tag")[:slug].must_equal "figure-slug-1"
    end

    it "uses the tag for a youtube link as a reference" do
      @renderer.image("tag@http://www.youtube.com/watch?v=fzlHs0UNmDY", "title", "alt_text")
      @renderer.lookup("tag")[:slug].must_equal "figure-slug-1"
    end

    it "uses the base filename for an image link as a reference" do
      @renderer.image("foo/bar/baz/link.png", "title", "alt_text")
      @renderer.lookup("link")[:slug].must_equal "figure-slug-1"
    end

    it "returns nil when a tag does not exist" do
      @renderer.image("foo@bar", "title", "alt_text")
      @renderer.lookup("bar").must_equal nil
    end
  end

  describe "#images" do
    it "contains an image when an image is parsed without a tag" do
      @renderer.image("link", "title", "alt_text")
      @renderer.images.count.must_equal 1
      @renderer.images.first[:slug].must_equal "figure-slug-1"
    end

    it "contains an image when an image is parsed with a tag" do
      @renderer.image("foo@link", "title", "alt_text")
      @renderer.images.count.must_equal 1
      @renderer.images.first[:slug].must_equal "figure-slug-1"
    end
  end
end
