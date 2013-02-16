require 'gutenberg/chapter'

module Gutenberg
  # The collection of resources that make up the book.
  class Book
    require 'yaml'

    # The title of the book
    attr_reader :title

    # The authors of the book
    attr_reader :authors

    # The preferred style to use to generate it
    attr_reader :style

    # The chapters gathered in this book
    attr_reader :chapters

    # Whether or not the table of contents is displayed. Default: false
    attr_reader :toc

    # Will create the book class and organize all metadata. Can be passed the
    # following options:
    # :yaml    - the filename of YAML that describes the book
    #
    # :title   - the title of the book (default: "Untitled")
    # :authors - an array of authors (default: ["anonymous"])
    # :style   - the styling to use upon generation (default: "basic")
    #
    # :chapters - an array of chapter files (default: [])
    #
    # :toc      - whether or not the table of contents is displayed (default: false)
    def initialize(options = {})
      if options[:yaml]
        data = YAML::load_file(options[:yaml])

        options[:title]    = options[:title]    || data["title"]
        options[:authors]  = options[:authors]  || data["authors"]
        options[:style]    = options[:style]    || data["style"]

        options[:toc]      = options[:toc]      || data["toc"]

        options[:chapters] = options[:chapters] || data["chapters"]
      end

      @title    = options[:title]   || "Untitled"
      @authors  = options[:authors] || ["anonymous"]
      @style    = options[:style]   || "basic"
      @toc      = options[:toc]     || false

      chapters = options[:chapters] || []

      @chapters = []
      chapters.each do |c|
        @chapters << Chapter.new(:markdown_file => c)
      end
    end

    def format_outline(outline)
      return "" if outline.nil?
      if outline.text == "References"
        "</ul><li><a href='##{outline.slug}'>#{outline.text}</a></li>#{format_outline(outline.sibling)}<ul>"
      else
        "<li><a href='##{outline.slug}'>#{outline.text}</a><ul>#{format_outline(outline.child)}</ul></li>#{format_outline(outline.sibling)}"
      end
    end
  end
end
