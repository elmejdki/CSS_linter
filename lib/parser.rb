require 'colorize'
class Parser
  attr_reader :error_output

  def initialize(file)
    @file = file
    @index = 0
    @error_output = []
  end

  def lunch_linter
    count = 0

    #FIXME: Add colorize gem to the gemfile and also use it here
    while @index < @file.length
      @index += 1 if @file[@index].empty?

      while /^\s*$/ === @file[@index] && @index < @file.length
        @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected empty line, expected only one empty line"
        @index += 1
      end

      check_selector()

      @index += 1
    end
  end

  def is_selector?(text)
    /^((((\s?\*|\s?(\.|#)?(\w+(-*_*\w+)?)+)+|(:\w+))(:\w+)?(\s?(>|,|\+|~)\s?)?(\*\s)?)+)\s?\{$/ === text
  end

  def whitespace_declaration_end_line?(text)
    validator = /^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+\S;\s+$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected whitespace at end of line of the declaration" if validator

    validator
  end

  def missing_semi_colon?(text)
    validator = /^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+(\w|"|')\s*$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Missing simi-colon at the end of the declaration" if validator

    validator
  end

  def whitespace_after_colon?(text)
    validator = /^\s*(\w+(-?\w+){0,3}):\s{2,}\S[\s\S]+\S;?\s*$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected whitespace after colon in declaration, expected only one space" if validator

    validator
  end

  def missing_space_after_colon?(text)
    validator = /^\s*(\w+(-?\w+){0,3}):\S[\s\S]+\S;?\s*$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Missing space after colon in declaration" if validator
    
    validator
  end

  def is_declaration?(text)
    /^\s*(\w+(-?\w+){0,3}):?\s{0,}\S[\s\S]+\S;?\s*$/ === text
  end

  def is_whitespace_colon?(text)
    validator = /^((((\s?\*|\s?(\.|#)?(\w+(-*_*\w+)?)+)+|(:\s+\w+))(:\s+\w+)?(\s(>|,|\+|~)\s)?(\*\s)?)+)\s*\{\s*$/ === @text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected whitespace in pseudo-class after colon" if validator

    validator
  end

  def missing_space_before_brac?(text)
    validator = /^\S[\S\s]+\S\{\s*$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Expected one space before '{'" if validator

    validator
  end

  def whitespace_after_brac?(text)
    validator = /^\S[\S\s]+\S\s?\{\s+$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Expected new line after '{'" if validator

    validator
  end

  def whitespace_end_line?(text)
    validator = /^\S[\S\s]+\S\s+$/ === text
    
    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected whitespace at end of line" if validator

    validator
  end

  def extras_whitespace_before_brac?(text)
    validator = /^\S[\S\s]+\S\s{2,}\{$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected whitespace before '{' only one space is allowed" if validator

    validator
  end

  def is_invalid?(text)
    validator = /^(\S)+\s\{$/ === text
    
    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Invalid selector go learn some CSS bro O.o" if validator

    validator
  end

  def whitespace_after_end_brac?(text)
    validator = /^\s*}\s+$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected whitespace after '}'" if validator

    validator
  end

  def whitespace_before_end_brac?(text)
    validator = /^\s+}\s*$/ === text

    @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unexpected whitespace before '}'" if validator

    validator
  end

  def is_end_selector?(text)
    /^\s*}\s*$/ === text
  end

  def unknown_word?(text)
    /^[\s\w]+$/ === text
  end

  def check_declarations
    while !@file[@index].include?('}') && @index < @file.length
      if is_declaration?(@file[@index])
        missing_space_after_colon?(@file[@index])
        whitespace_after_colon?(@file[@index])
        missing_semi_colon?(@file[@index])
        whitespace_declaration_end_line?(@file[@index])
      elsif unknown_word?(@file[@index])
        @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unknown word"
      end

      @index += 1
    end
  end

  def check_selector_end
    if is_end_selector?(@file[@index])
      whitespace_after_end_brac?(@file[@index])
      whitespace_before_end_brac?(@file[@index])
    elsif unknown_word?(@file[@index])
      @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unknown word"
    end

    @index += 1
  end

  def check_selector
    if is_selector?(@file[@index])
      is_whitespace_colon?(@file[@index])
      missing_space_before_brac?(@file[@index])
      whitespace_after_brac?(@file[@index])
      whitespace_end_line?(@file[@index])
      extras_whitespace_before_brac?(@file[@index])

      @index += 1

      check_declarations()

      check_selector_end()
    elsif is_invalid?(@file[@index])
      @index += 1
    elsif unknown_word?(@file[@index])
      @error_output << ("%-11s" % "line: #{@index + 1} ").colorize(:light_black) + "x".colorize(:red) + "  Unknown word"
      @index += 1
    end
  end

  def print_results
    if @error_output.length.zero?
      puts "Great Job your code is very clean."
    end

    i = 0
    while i < @error_output.length
      puts error_output[i]
      i += 1
    end
  end
end