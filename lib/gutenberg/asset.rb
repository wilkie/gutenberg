module Gutenberg
  # Represents an asset file.
  class Asset
    require 'fileutils'
    require 'yaml'

    # The full path to the asset file.
    attr_reader :path

    # The name of the asset.
    attr_reader :name

    # The type of asset. Types include:
    # :image      = An image file
    # :script     = A dynamic script
    # :stylesheet = Stylesheet
    attr_reader :type

    # Whether or not this asset should have attribution.
    def attribute?
      @attribution
    end

    # The name of the author of this asset.
    attr_reader :author

    # The url used to identify the author.
    attr_reader :author_url

    # The collection this asset is a part of.
    attr_reader :collection

    # The url used for the collection.
    attr_reader :collection_url

    # The path to assets stored with the gem.
    def Asset.path
      "#{File.dirname(__FILE__)}/assets"
    end

    # Creates a reference to an asset given a path.
    def initialize(path, check_path = nil)
      # Check both local path and gem path
      if File.exists?(path)
        @path = File.expand_path(path)
      elsif File.exists?("#{Asset.path}/#{path}")
        @path = "#{Asset.path}/#{path}"
      elsif (not check_path.nil?) and File.exists?("#{check_path}/#{path}")
        @path = "#{check_path}/#{path}"
      else
        raise Errno::ENOENT
      end

      @path = File.expand_path(@path)

      @ext  = File.extname(@path)

      case @ext
      when ".css", ".sass", ".less", ".scss"
        @type = :stylesheet
      when ".js"
        @type = :script
      else
        @type = :image
      end

      # Look for a metadata file
      @metadata_path = File.expand_path(
        @path.chomp(File.extname(@path))) + ".yml"

      if File.exists?(@metadata_path)
        metadata = YAML.load_file(@metadata_path)
        @author = metadata["author"] || "anonymous"
        @author_url = metadata["author-website"]
        @collection = metadata["collection"]
        @collection_url = metadata["collection-website"]
        @name = metadata["name"]
        @attribution = metadata["attribution"]
        @attribution = true if metadata["attribution"].nil?
      else
        @attribution = false
        @author = "anonymous"
        @metadata_path = nil
      end
    end

    # Yields the asset path from the given path.
    def path_from(from)
      subpath = File.basename @path.chomp(File.basename(@path))
      from = "#{from}/" if from && !from.end_with?("/")
      "#{from}#{subpath}/#{File.basename(@path)}"
    end

    # Copies the asset to the given path.
    def copy(to)
      subpath = File.basename @path.chomp(File.basename(@path))
      FileUtils.mkdir_p "#{to}/#{subpath}"
      begin
        FileUtils.cp @path, "#{to}/#{subpath}"
        FileUtils.cp @metadata_path, "#{to}/#{subpath}" if @metadata_path
      rescue ArgumentError => e
        # For when the source and destination are the same
      end
    end
  end
end
