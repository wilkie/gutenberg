require 'gutenberg/node'
require 'gutenberg/table_renderer'

module Gutenberg
  require 'redcarpet'

  # Determines how to render markdown tags into HTML.
  class MarkdownRenderer < Redcarpet::Render::HTML
    require 'nokogiri'
    require 'cgi'
    require 'text/hyphen'

    # Returns the root Gutenberg::Node for the chapter contents.
    # You can traverse this data structure to get a layout of the headers
    # throughout the chapter.
    attr_reader :outline

    # The title of the chapter as given by the first header found in the
    # content.
    attr_reader :title

    # The images contained within this chapter. Default: []
    attr_reader :images

    # The tables contained within this chapter. Default: []
    attr_reader :tables

    # Creates a new renderer that can be given to Redcarpet. It expects to
    # receive a slug to use as a safe anchor and the chapter name in case a
    # primary header is not used. The name is overriden by a primary header.
    # It can receive an index that is used to indicate the chapter number
    # of this chapter. It can be a string to indicate roman numerals. It can
    # be an empty string whenever it is meant to be omitted.
    def initialize(slug, name, language, style, index, *args)
      @images = []
      @tables = []
      @outline = Node.new(name || "Untitled")
      @last = @outline
      @slug = slug
      @hyphenator = Text::Hyphen.new(:language => language)
      @style = style
      @index = index.to_s || ""

      @figure_count = 0
      @table_count = 0

      @lookup = {}
      super *args
    end

    # Generates HTML for a markdown paragraph.
    def paragraph(text)
      # Determine if this text represents a table
      if text.start_with? '!table'
        return parse_table(text)
      end

      # Don't parse html tags
      if text.start_with?("<") && !text.start_with?("<strong") && !text.start_with?("<em")
        return text
      end

      # Find directive
      match = text.match /^!([^ ]+)\s(.*)/

      directive = match[1] if match
      text = match[2] if match
      text = text.split(' ').map do |word|
        if word.start_with? '@[' and word.end_with? ']'
          word
        else
          @hyphenator.visualize(word, "&shy;")
        end
      end.join(' ')

      if directive
        "<div class='inset #{directive}'><img src='#{@style.image_for(directive)}' /><p>#{text}</p></div>\n\n"
      else
        "<p>#{text}</p>\n\n"
      end
    end

    # Parses a table.
    def parse_table(text)
      return if text.empty? or not text.lines.first.start_with?("!table")
      caption = text.lines.first[6..-1].strip
      tag = ""
      unless caption.start_with?('&quot;') or not caption.include?(' ')
        tag, caption = caption.split(' ', 2)
      end
      caption = caption[6..-1].strip if caption.start_with? '&quot;'
      caption = caption[0..-7].strip if caption.end_with? '&quot;'
      table_renderer = Gutenberg::TableRenderer.new

      table_renderer.parse_block(text).caption = ""

      # Determine figure slug
      @table_count += 1
      id = "table-#{@slug}-#{@table_count}"

      full_index = "#{@index}-#{@table_count}"
      if @index.empty?
        full_index = @table_count.to_s
      end
      tag = "table-#{full_index}" if tag == ""

      # Add slug to reference lookup
      @lookup[tag] = {:slug       => id,
                      :index      => @table_count,
                      :caption    => caption,
                      :full_index => full_index}

      @tables << @lookup[tag]
      "<figure class='table' id='#{id}'>\n#{table_renderer.to_html}<figcaption><strong>Table #{full_index}</strong>: #{caption}</figcaption></figure>"
    end

    # Generates HTML for markdown blockquotes.
    def block_quote(text)
      # un <p> tag the blockquote because seriously now
      text = text.match(/^<p>(.*)<\/p>$/)[1] if text.start_with? "<p>"
      stripped_text = Nokogiri::HTML(text).xpath("//text()").remove.text
      match = text.match /^(.*)--(.*)$/
      if match
        "<blockquote><img src='#{@style.image_for('quote')}' /><p>#{match[1].strip}</p><div><cite>#{match[2].strip}</cite></div></blockquote>\n\n"
      else
        "<blockquote><img src='#{@style.image_for('quote')}' /><p>#{text}</p></blockquote>\n\n"
      end
    end

    # Generates HTML for a markdown codespan.
    def codespan(code)
      # Since codespans are inline with text, let's make sure we never
      # break up a codespan on wordwrap
      "<code>#{CGI::escapeHTML(code).gsub(/\-/, "&#8209;")}</code>"
    end

    # Generates HTML for a markdown code block.
    def block_code(code, language)
      code = CGI::escapeHTML(code)
      new_code = ""
      last_number = -1
      code.lines do |l|
        m = l.match(/^\!(\d)\!(.*)$/)
        if m
          if m[1] != last_number
            l = "<div class='ref_line s1 c#{m[1]}'><div>#{m[2]}\n"
            if last_number != -1
              l = "</div></div>" << l
            end
          else
            l = "#{m[2]}\n"
          end
          last_number = m[1]
        else
          if last_number != -1
            l = "</div></div>" << l
          end
          last_number = -1
        end
        new_code << l
      end
      "<pre><code>#{language}#{new_code}</code></pre>"
    end

    # Generates HTML for a markdown image.
    def image(link, title, alt_text)
      caption = title
      title = Nokogiri::HTML(title).xpath("//text()").remove

      tag = ""
      if link.include? '@'
        tag, link = link.split('@')
      else
        tag = File.basename(link.chomp(File.extname(link)))
      end

      img_source = "<img src='#{link}' title='#{title}' alt='#{alt_text}' />"

      if link.match "http[s]?://(www.)?youtube.com"
        # embed the youtube link
        youtube_hash = link.match("youtube.com/.*=(.*)$")[1]
        img_source = "<figure class='youtube'><div class='youtube_fixture'><img src='/images/youtube_placeholder.png' /><iframe class='youtube_frame' longdesc='#{alt_text}' src='http://www.youtube.com/embed/#{youtube_hash}'>#{alt_text}</iframe></div></figure>"
      end

      # Determine figure slug
      @figure_count += 1
      id = "figure-#{@slug}-#{@figure_count}"

      # Add slug to reference lookup
      @lookup[tag] = {:slug       => id,
                      :index      => @figure_count,
                      :caption    => caption,
                      :full_index => "#{@index}-#{@figure_count}"}

      @images << @lookup[tag]

      caption = "<br /><figcaption><strong>Figure #{@index.empty? ? "" : "#{@index}-"}#{@figure_count}</strong>: #{caption}</figcaption>" unless caption == ""
      "<figure class='image' id='#{id}'>#{img_source}#{caption}</figure>\n\n"
    end

    # Generates HTML for a markdown header.
    def header(text, header_level)
      new_node = Node.new text
      if header_level == 1
        @title = @title || text.strip
        @outline.text = text
        new_node = @outline
      elsif header_level == @last.level
        new_node.parent = @last.parent
        @last.sibling = new_node
      elsif header_level > @last.level
        new_node.parent = @last
        @last.child = new_node
      elsif header_level < @last.level
        new_node.parent = @last.parent.parent
        @last.parent.sibling = new_node
      end
      @last = new_node

      "<h#{header_level} id='#{new_node.slug}'>#{text}</h#{header_level}>\n\n"
    end

    # Retrieve the slug that identifies the given reference.
    def lookup(reference)
      @lookup[reference]
    end
  end
end
