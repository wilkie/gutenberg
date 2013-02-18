require 'gutenberg/asset'

module Gutenberg
  # Represents a style that can be applied to a book.
  class Style
    require 'yaml'

    # The name of the style. Default: "Untitled"
    attr_reader :name

    # The author of the style. Default: "anonymous"
    attr_reader :author

    # Description of the style. Default: ""
    attr_reader :description

    # Whether or not attribution is requested. Default: true
    def attribute?
      @attribute
    end

    # The list of assets required by the style. Default: []
    attr_reader :assets

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

        options[:author]      ||= data["author"]
        options[:description] ||= data["description"]
        options[:assets]      ||= data["assets"]
        options[:images]      ||= data["images"]
        options[:attribution]   = data["attribution"] if options[:attribution].nil?
      end

      # Assign values
      @author      = options[:author]      || "anonymous"
      @attribute   = options[:attribution] unless options[:attribution].nil?
      @attribute   = true if @attribute.nil?
      @description = options[:description] || ""
      assets       = options[:assets]      || []

      @assets = assets.map{|a| Gutenberg::Asset.new(a, @path)}

      @images = options[:images] || {}

      @name = name
    end

    def image_for(type)
      @images[type]
    end

    def copy(to)
      @assets.each do |a|
        a.copy(to)
      end
    end
  end
end
