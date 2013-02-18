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
    # :image  = An image file
    # :script = A dynamic script
    # :css    = Stylesheet
    attr_reader :type

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
    def initialize(path)
      # Check both local path and gem path
      if File.exists?(path)
        @path = File.expand_path(path)
      elsif File.exists?("#{Asset.path}/#{path}")
        @path = "#{Asset.path}/#{path}"
      else
        raise Errno::ENOENT
      end

      @path = File.expand_path(@path)

      # Look for a metadata file
      metadata_path = File.expand_path(
        @path.chomp(File.extname(@path))) + ".yml"

      if File.exists?(metadata_path)
        metadata = YAML.load_file(metadata_path)
        @author = metadata["author"]
        @author_url = metadata["author-website"]
        @collection = metadata["collection"]
        @collection_url = metadata["collection-website"]
        @name = metadata["name"]
      end
    end

    def copy(to)
      subpath = File.basename @path.chomp(File.basename(@path))
      FileUtils.mkdir_p "#{to}/#{subpath}"
      FileUtils.cp @path, "#{to}/#{subpath}"
    end
  end
end
