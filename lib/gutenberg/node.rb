module Gutenberg
  # Represents a header or subheader in chapter content.
  class Node
    # The first child of this node.
    attr_accessor :child

    # The first sibling of this node.
    attr_accessor :sibling

    # The immediate parent of this node.
    attr_accessor :parent

    # The text of this header.
    attr_accessor :text

    # Creates a new Node with the given relationship.
    def initialize text, parent=nil, sibling=nil, child=nil
      @parent = parent
      @text = text
      @sibling = sibling
      @child = child
    end

    # Determines the level of this node. A primary header (chapter name) is
    # level 1.
    def level
      level = 1
      current = @parent
      until current.nil? do
        current = current.parent
        level = level + 1
      end
      level
    end

    # Determines a slug version of the header text.
    def slug
      @text.to_slug.to_s
    end
  end
end
