require 'gutenberg/asset'

module Gutenberg
  # Represents a style that can be applied to a book.
  class Style
    require 'yaml'
    require 'fileutils'

    # The name of the style. Default: "Untitled"
    attr_reader :name

    # The author of the style. Default: "anonymous"
    attr_reader :author

    # The url that represents the author. Default: nil
    attr_reader :author_url

    # Description of the style. Default: ""
    attr_reader :description

    # Whether or not attribution is requested. Default: true
    def attribute?
      @attribute
    end

    # The list of assets required by the style. Default: []
    attr_reader :assets

    # The list of scripts required by the style. Default: []
    attr_reader :scripts

    # The list of stylesheets required by the style. Default: []
    attr_reader :stylesheets

    # The list of images required by the style. Default: []
    attr_reader :images

    # The path to the style information. Default: nil
    attr_reader :path

    # Creates a reference to style data which can be used to organize
    # the data and assets and produce the book.
    def initialize(name, options={})
      @path = "#{File.dirname(__FILE__)}/styles/#{name}"
      # Ensure style exists
      unless File.exists?(@path)
        raise Errno::ENOENT
      end

      # Load configuration file
      if File.exists?("#{@path}/config.yml")
        data = YAML.load_file("#{@path}/config.yml")

        name = data["name"] if data["name"]
        options[:author]      ||= data["author"]
        options[:author_url]  ||= data["author-website"]
        options[:description] ||= data["description"]
        options[:assets]      ||= data["assets"]
        options[:images]      ||= data["images"]
        options[:attribution]   = data["attribution"] if options[:attribution].nil?
      end

      # Assign values
      @author      = options[:author]      || "anonymous"
      @author_url  = options[:author_url]
      @attribute   = options[:attribution] unless options[:attribution].nil?
      @attribute   = true if @attribute.nil?
      @description = options[:description] || ""
      assets       = options[:assets]      || []

      @assets = assets.map{|a| Gutenberg::Asset.new(a, @path)}

      @images = []
      @stylesheets = []
      @scripts = []

      @assets.each do |a|
        case a.type
        when :image
          @images << a
        when :script
          @scripts << a
        when :stylesheet
          @stylesheets << a
        end
      end

      @images_for = options[:images] || {}

      @name = name
    end

    # Returns the image location for the given image tag.
    def image_for(type)
      "style/#{@images_for[type]}" if @images_for[type]
    end

    # Copies the assets to the given path.
    def copy(to)
      FileUtils.mkdir_p "style"
      @assets.each do |a|
        a.copy("style/#{to}")
      end
    end
  end
end
