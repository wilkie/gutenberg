require_relative 'helper'
require_relative '../lib/gutenberg/table_renderer.rb'

describe Gutenberg::TableRenderer do
  describe "#parse_block" do
    it "should parse a one row table" do
      Gutenberg::TableRenderer.new.parse_block("|aaa|bbb|").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td[^>]*>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a one row table surrounded by a border" do
      Gutenberg::TableRenderer.new.parse_block("|---|---|\n|aaa|bbb|\n|---|---|").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td[^>]*>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a one row table surrounded by a border" do
      Gutenberg::TableRenderer.new.parse_block("|---|---|\n|aaa|bbb|\n|---|---|").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td[^>]*>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a two row table surrounded by a border" do
      Gutenberg::TableRenderer.new.parse_block("|---|---|\n|aaa|bbb|\n|---|---|\n|ccc|ddd|\n|---|---|").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td[^>]*>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<tr>\s*<td[^>]*>ccc<\/td>\s*<td[^>]*>ddd<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a two row table without a border" do
      Gutenberg::TableRenderer.new.parse_block("\naaa:bbb\nccc:ddd").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td[^>]*>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<tr>\s*<td[^>]*>ccc<\/td>\s*<td[^>]*>ddd<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a two row table with double borders" do
      Gutenberg::TableRenderer.new.parse_block("aaa:bbb\n|===|===|\nccc:ddd").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td class=['"][^'"]*bottom_border_double[^'"]*['"][^>]*>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<tr>\s*<td class=['"][^'"]*top_border_double[^'"]*['"][^>]*>ccc<\/td>\s*<td[^>]*>ddd<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a two row table with single borders" do
      Gutenberg::TableRenderer.new.parse_block("aaa:bbb\n|---|---|\nccc:ddd").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td class=['"][^'"]*bottom_border_single[^'"]*['"][^>]*>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<tr>\s*<td class=['"][^'"]*top_border_single[^'"]*['"][^>]*>ccc<\/td>\s*<td[^>]*>ddd<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a two row table without borders" do
      Gutenberg::TableRenderer.new.parse_block("aaa:bbb\n|...|...|\nccc:ddd").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td>aaa<\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<tr>\s*<td>ccc<\/td>\s*<td[^>]*>ddd<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a two row table with vertical borders" do
      Gutenberg::TableRenderer.new.parse_block("aaa|bbb\nccc|ddd").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td class=['"]right_border['"]>aaa<\/td>\s*<td class=['"]left_border['"]>bbb<\/td>\s*<\/tr>\s*<tr>\s*<td class=['"]right_border['"]>ccc<\/td>\s*<td class=['"]left_border['"]>ddd<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse a two row table with vertical borders" do
      Gutenberg::TableRenderer.new.parse_block("aaa|bbb\nccc|ddd").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td class=['"]right_border['"]>aaa<\/td>\s*<td class=['"]left_border['"]>bbb<\/td>\s*<\/tr>\s*<tr>\s*<td class=['"]right_border['"]>ccc<\/td>\s*<td class=['"]left_border['"]>ddd<\/td>\s*<\/tr>\s*<\/table>/m
    end

    it "should parse allow markdown within table cell" do
      Gutenberg::TableRenderer.new.parse_block("<em>aaa</em>|bbb").to_html
        .must_match /^<table[^>]*>[^<]*<tr>[^<]*<td[^>]*><em>aaa<\/em><\/td>\s*<td[^>]*>bbb<\/td>\s*<\/tr>\s*<\/table>/m
    end
  end

  describe "#cols" do
    it "should return the number of the columns in the 1 column table" do
      Gutenberg::TableRenderer.new.parse_block("aaa").cols.must_equal 1
    end

    it "should return the number of the columns in the 2 column table" do
      Gutenberg::TableRenderer.new.parse_block("aaa|bbb").cols.must_equal 2
    end
  end

  describe "#rows" do
    it "should return the number of the rows in the 1 row table" do
      Gutenberg::TableRenderer.new.parse_block("aaa|bbb").rows.must_equal 1
    end

    it "should return the number of the rows in the 2 row table" do
      Gutenberg::TableRenderer.new.parse_block("aaa|bbb\nccc|ddd").rows.must_equal 2
    end

    it "should return the number of the rows in the 2 row table with border separator" do
      Gutenberg::TableRenderer.new.parse_block("aaa|bbb\n|---|---|\nccc|ddd").rows.must_equal 2
    end
  end

  describe "#caption" do
    it "should have an empty caption by default" do
      Gutenberg::TableRenderer.new.caption.must_equal ""
    end

    it "should render the caption when one is given" do
      table = Gutenberg::TableRenderer.new
      table.caption = "foobar"
      table.to_html.must_match /^<table[^>]*>\s*<caption>foobar<\/caption>/m
    end

    it "should not render the caption when one is not given" do
      table = Gutenberg::TableRenderer.new
      table.caption = "foobar"
      table.caption = ""
      table.to_html.must_match /^<table[^>]*>[^<]*<\/table>/m
    end
  end

  describe "#to_html" do
    it "should return an empty <table> tag at minimum" do
      Gutenberg::TableRenderer.new.to_html.must_match(
        /^<table[^>]*>[^<]*<\/table>/m)
    end
  end
end
