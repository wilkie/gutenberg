require 'gutenberg/chapter'
require 'gutenberg/style'

module Gutenberg
  # The collection of resources that make up the book.
  class Book
    require 'yaml'

    # The title of the book. Default: "Untitled"
    attr_reader :title

    # The authors of the book. Default: ["anonymous"]
    attr_reader :authors

    # The preferred style represented by a Gutenberg::Style to use to generate it.
    # By default, this will load a generic basic style.
    attr_reader :style

    # The chapters gathered in this book as Gutenberg::Chapter. Default: []
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
      @toc      = options[:toc]     || false
      style     = options[:style]   || "basic"

      @style = Gutenberg::Style.new(style)

      chapters = options[:chapters] || []

      @chapters = []
      chapters.each_with_index do |c,i|
        @chapters << Chapter.new(:markdown_file => c, :style => @style, :index => i+1)
      end
    end
  end
end
