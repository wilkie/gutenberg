module Gutenberg
  # Generates HTML for a table through procedural generation.
  class TableRenderer
    # The height of the table.
    attr_reader :rows

    # The width of the table.
    attr_reader :cols

    # The caption for this table. Defaults to ""
    attr_accessor :caption

    # Creates a renderer that expects rows to be the given width.
    def initialize()
      @html = ""
      @caption = ""

      @rows = 0
      @cols = 0

      @top_row = []
      @last_row_was_separator = true
    end

    # Automatically parse a block of text representing a table.
    def parse_block(text)
      text.lines.map(&:strip).each do |line|
        parse_line(line) unless line.start_with? '!table'
        @caption = line[6..-1].strip if line.start_with? '!table'
      end
      self
    end

    # Automatically adds the row given by the line.
    def parse_line(line)
      cell_index = 0

      row_is_separator = false

      # Determine new attributes and cell content
      until line.empty? do
        cell = {}

        # Determine left-right borders
        cell[:left_border] = true if line.start_with? '|'
        line = line[1 .. -1] if line.match(/^(\||:)/)
        pipe  = line.index('|')
        colon = line.index(':')
        index = nil
        index = pipe if pipe
        index = colon if index.nil? || (colon && colon < index)
        cell[:right_border] = true if index && index == pipe

        if index
          cell[:content] = line[0..index-1].strip
          line = line[index .. -1] || ""
          line = line.strip
        else
          cell[:content] = line.strip
          line = ""
        end

        # Determine top-bottom borders
        if cell[:content].match /^[-=.]+$/
          # This row is a separator row
          row_is_separator = true

          # Add attributes to the row
          if cell[:content].start_with? '-'
            if @row
              @row[cell_index][:bottom_border] = :single
            else
              @top_row << {:bottom_border => :single}
            end
          elsif cell[:content].start_with? '='
            if @row
              @row[cell_index][:bottom_border] = :double
            else
              @top_row << {:bottom_border => :double}
            end
          else
            @top_row << {} unless @row
          end
        elsif not row_is_separator
          # Add a new row if this is the first cell in that row
          if cell_index == 0
            add_row
          end

          # Inherit borders from adjacent cell
          if @last_row_was_separator
            if @last_row
              cell[:top_border] = @last_row[cell_index][:bottom_border] if @last_row && @last_row[cell_index]
            else
              cell[:top_border] = @top_row[cell_index][:bottom_border] if @top_row[cell_index]
            end
          end

          # Add the cell
          if cell[:content] && cell[:content] != ""
            add_cell(cell)
          end
        end

        cell_index += 1
      end

      @cols = cell_index

      @last_row_was_separator = row_is_separator
      self
    end

    # Adds a cell to the current row.
    def add_cell(cell)
      @row << cell
      self
    end

    # Completes the row. Automatically done if add_row is called without calling
    # complete_row first.
    def complete_row
      if @row
        @row.each do |cell|
          attributes = ""
          classes = []
          cell.keys.each{|k| classes << k unless (k == :content ||
                                                  k == :top_border ||
                                                  k == :bottom_border)}
          if cell[:top_border] == :single
            classes << :top_border_single
          elsif cell[:top_border] == :double
            classes << :top_border_double
          end

          if cell[:bottom_border] == :single
            classes << :bottom_border_single
          elsif cell[:bottom_border] == :double
            classes << :bottom_border_double
          end

          attributes = classes.empty? ? "" : " class='#{classes.join(' ')}'"

          @html << "    <td#{attributes}>#{cell[:content]}</td>\n"
        end
        @html << "  </tr>\n"
      end

      @last_row = @row
      @row = nil
    end

    # Adds a new row to the table.
    def add_row
      complete_row
      @row = []
      @rows += 1

      @html << "  <tr>\n"
      self
    end

    # Yields the html of the table.
    def to_html
      complete_row
      caption = "<caption>#{@caption}</caption>" unless @caption.empty?
      "<table>\n#{caption}\n#{@html}</table>\n\n"
    end
  end
end
