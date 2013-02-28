require 'gutenberg/markdown_renderer'

module Gutenberg
  # Represents a chapter of the book.
  class Chapter
    require 'redcarpet'
    require 'babosa'

    # The title of the chapter. Default: "Untitled"
    attr_reader :title

    # The list of authors responsible for this chapter. Default: []
    attr_reader :authors

    # The friendly identifier for this chapter: Default: "chapter"
    attr_reader :slug

    # The content of this chapter in a raw format. Default: ""
    attr_reader :content

    # The content of this chapter rendered in html. Default: ""
    attr_reader :html

    # The outline of this chapter. This gives the root node of the document
    # tree.
    attr_reader :outline

    # The index of this chapter. Default: ""
    attr_reader :index

    # The images contained in this chapter. Default: []
    attr_reader :images

    # The language this chapter is written in. Default: "en_us"

    # Creates a new representation of a Chapter where options may be specified:
    # :markdown_file - use the given file for the chapter content
    #
    # :title         - the title of the chapter (default: "Untitled")
    # :content       - the content for the chapter (default: "")
    # :authors       - an array of authors (default: [])
    # :slug          - the slug to identify this chapter (default: inferred from title)
    # :language      - the language this chapter is written in (default: en_us)
    # :style         - the Gutenberg::Style class to use to render the content
    # :index         - the numerical representation of the chapter. This will precede
    #                  things such as figure captions. If the index is "3" then, figures
    #                  will be listed as 3-1, then 3-2, etc. This will be omitted when
    #                  the index is given as an empty string. (default: "")
    def initialize(options = {})
      @format = options[:format] || :text
      @images = []

      # Look for and load any special files
      if options[:markdown_file]
        options[:slug] ||= options[:markdown_file].gsub(/.md$/, "").to_slug.normalize.to_s

        # Will throw on error
        options[:content] ||= File.read(options[:markdown_file])

        @format = :markdown
      end

      # In case we don't have any content... default to empty
      options[:content] ||= ""

      # Grab metadata from content
      match = options[:content].match(/^---$(.*?)^---$(.*)/m)

      unless match.nil?
        meta_data = match[1].strip
        options[:content] = match[2].strip

        meta_data = YAML.load(meta_data)

        options[:title]    ||= meta_data["title"]
        options[:authors]  ||= meta_data["authors"]
        options[:scripts]  ||= meta_data["scripts"]
        options[:summary]  ||= meta_data["summary"]
        options[:language] ||= meta_data["language"]
        options[:index]      = meta_data["index"] if meta_data["index"]
      end

      options[:language] ||= "en_us"
      options[:index]    ||= ""

      case @format
      when :markdown
        renderer = Gutenberg::MarkdownRenderer.new(options[:slug],
                                                   options[:title],
                                                   options[:language],
                                                   options[:style],
                                                   options[:index])
        markdown = Redcarpet::Markdown.new(renderer, :fenced_code_blocks => true)

        @html = markdown.render(options[:content])
        @outline = renderer.outline;

        # Replace references
        @html.gsub! /<p>(.*?)<\/p>/ do
          s = $1.gsub /\@\[([^\]]+)\]/ do
            data = renderer.lookup($1)
            if data
              "<a href='##{data[:slug]}'>#{data[:full_index]}</a>"
            else
              $&
            end
          end
          "<p>#{s}</p>"
        end if @html

        # title can be inferred from markdown
        options[:title] = options[:title] || renderer.title

        # Get the image list
        @images = renderer.images
      when :html
        @html = @content
      else
        @html = "<pre>#{@content}</pre>"
      end

      @title    = options[:title]   || "Untitled"
      @authors  = options[:authors] || []
      @slug     = options[:slug]    || "chapter"
      @content  = options[:content] || ""
      @language = options[:language]
      @index    = options[:index]
    end
  end
end
