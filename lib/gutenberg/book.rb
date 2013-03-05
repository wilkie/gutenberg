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

    # The prefaces gathered in this book as Gutenberg::Chapter. Default: []
    attr_reader :prefaces

    # Whether or not the table of contents is displayed. Default: false
    attr_reader :toc

    # The images used throughout the book.
    attr_reader :images

    # The tables used throughout the book.
    attr_reader :tables

    # The image to use for the cover. Default: nil
    attr_reader :cover

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

        options[:title]    ||= data["title"]
        options[:authors]  ||= data["authors"]
        options[:style]    ||= data["style"]

        options[:toc]      ||= data["toc"]

        options[:prefaces] ||= data["prefaces"]
        options[:chapters] ||= data["chapters"]

        options[:cover]    ||= data["cover"]
      end

      @cover    = options[:cover]
      @title    = options[:title]   || "Untitled"
      @authors  = options[:authors] || ["anonymous"]
      @toc      = options[:toc]     || false
      style     = options[:style]   || "basic"

      @style = Gutenberg::Style.new(style)

      chapters = options[:chapters] || []
      prefaces = options[:prefaces] || []

      @images   = []
      @tables   = []

      @prefaces = []
      prefaces.each_with_index do |p,i|
        preface = Chapter.new(:markdown_file => p, :style => @style, :index => i+1)
        @prefaces << preface
        @images.concat preface.images
        @tables.concat preface.tables
      end

      @chapters = []
      chapters.each_with_index do |c,i|
        chapter = Chapter.new(:markdown_file => c, :style => @style, :index => i+1)
        @chapters << chapter
        @images.concat chapter.images
        @tables.concat chapter.tables
      end
    end
  end
end
