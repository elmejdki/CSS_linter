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
        @error_output << "line:#{@index + 1} x Unexpected empty line, expected only one empty line"
        @index += 1
      end

      check_selector()

      @index += 1
    end
  end

  def is_selector?
    /^((((\s?\*|\s?(\.|#)?(\w+(-*_*\w+)?)+)+|(:\w+))(:\w+)?(\s?(>|,|\+|~)\s?)?(\*\s)?)+)\s?\{$/ === @file[@index]
  end

  def whitespace_declaration_end_line?
    validator = /^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+\S;\s+$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Unexpected whitespace at end of line of the declaration" if validator

    validator
  end

  def missing_semi_colon?
    validator = /^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+(\w|"|')\s*$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Missing simi-colon at the end of the declaration" if validator

    validator
  end

  def whitespace_after_colon?
    validator = /^\s*(\w+(-?\w+){0,3}):\s{2,}\S[\s\S]+\S;?\s*$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Unexpected whitespace after colon in declaration, expected only one space" if validator

    validator
  end

  def missing_space_after_colon?
    validator = /^\s*(\w+(-?\w+){0,3}):\S[\s\S]+\S;?\s*$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Missing space after colon in declaration" if validator
    
    validator
  end

  def is_declaration?
    /^\s*(\w+(-?\w+){0,3}):?\s{0,}\S[\s\S]+\S;?\s*$/ === @file[@index]
  end

  def is_whitespace_colon?
    validator = /^((((\s?\*|\s?(\.|#)?(\w+(-*_*\w+)?)+)+|(:\s+\w+))(:\s+\w+)?(\s(>|,|\+|~)\s)?(\*\s)?)+)\s*\{\s*$/ === @text

    @error_output << "line:#{@index + 1} x Unexpected whitespace in pseudo-class after colon" if validator

    validator
  end

  def missing_space_before_brac?
    validator = /^\S[\S\s]+\S\{\s*$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Expected one space before '{'" if validator

    validator
  end

  def whitespace_after_brac?
    validator = /^\S[\S\s]+\S\s?\{\s+$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Expected new line after '{'" if validator

    validator
  end

  def whitespace_end_line?
    validator = /^\S[\S\s]+\S\s+$/ === @file[@index]
    
    @error_output << "line:#{@index + 1} x Unexpected whitespace at end of line" if validator

    validator
  end

  def extras_whitespace_before_brac?
    validator = /^\S[\S\s]+\S\s{2,}\{$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Unexpected whitespace before '{' only one space is allowed" if validator

    validator
  end

  def is_invalid?
    validator = /^(\S)+\s\{$/ === @file[@index]
    
    @error_output << "line:#{@index + 1} x Invalid selector go learn some CSS bro O.o" if validator

    validator
  end

  def whitespace_after_end_brac?
    validator = /^\s*}\s+$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Unexpected space after '}'" if validator

    validator
  end

  def whitespace_before_end_brac?
    validator = /^\s+}\s*$/ === @file[@index]

    @error_output << "line:#{@index + 1} x Unexpected space before '}'" if validator

    validator
  end

  def is_end_selector?
    /^\s*}\s*$/ === @file[@index]
  end

  def unknown_word?
    /^[\s\w]+$/ === @file[@index]
  end

  def check_declarations
    while !@file[@index].include?('}') && @index < @file.length
      if is_declaration?
        missing_space_after_colon?()
        whitespace_after_colon?()
        missing_semi_colon?()
        whitespace_declaration_end_line?()
      elsif unknown_word?()
        @error_output << "line:#{@index + 1} x Unknown word"
      end

      @index += 1
    end
  end

  def check_selector_end
    if is_end_selector?()
      whitespace_after_end_brac?()
      whitespace_before_end_brac?()
    elsif unknown_word?()
      @error_output << "line:#{@index + 1} x Unknown word"
    end

    @index += 1
  end

  def check_selector
    if is_selector?
      is_whitespace_colon?()
      missing_space_before_brac?()
      whitespace_after_brac?()
      whitespace_end_line?()
      extras_whitespace_before_brac?()

      @index += 1

      check_declarations()

      check_selector_end()
    elsif is_invalid?()
      @index += 1
    elsif unknown_word?
      @error_output << "line:#{@index + 1} x Unknown word"
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