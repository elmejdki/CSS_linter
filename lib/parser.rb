require 'colorize'
require_relative 'file_opener'

# rubocop:disable Metrics/ClassLength
class Parser
  attr_reader :error_output

  def initialize(file_path)
    @file = FileOpener.open_file(file_path)
    @index = 0
    @error_output = []
  end

  def lunch_linter
    while @index < @file.length
      handle_empty_lines

      check_selector

      @index += 1
    end
  end

  def print_results
    puts 'Great Job Your Code Is Very Clean.'.colorize(:green) if @error_output.length.zero?

    i = 0
    while i < @error_output.length
      puts @error_output[i]
      i += 1
    end
  end

  def selector?(text)
    text.match?(/^\s*((((\s?\*|\s?(\.|#)?(\w+(-*_*\w+)?)+)+|(:\s*\w+))(:\s*\w+)?(\s?(>|,|\+|~)\s?)?(\*\s)?)+)\s?\{\s*$/)
  end

  def declaration?(text)
    text.match?(/^\s*(\w+(-?\w+){0,3}):\s{0,}\S[\s\S]+\S;?\s*$/)
  end

  def end_selector?(text)
    text.match?(/^\s*}\s*$/)
  end

  def unknown_word?(text)
    text.match?(/^[\s\w]+$/)
  end

  def whitespace_declaration_end_line?(text)
    validator = text.match?(/^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+\S;\s+$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' at end of the line of the declaration'
    end

    validator
  end

  def missing_semi_colon?(text)
    validator = text.match?(/^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+(\w|"|')\s*$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Missing simi-colon at'\
      ' the end of the declaration'
    end

    validator
  end

  def whitespace_after_colon?(text)
    validator = text.match?(/^\s*(\w+(-?\w+){0,3}):\s{2,}\S[\s\S]+\S;?\s*$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' after the colon in the declaration, expected only one space'
    end

    validator
  end

  def missing_space_after_colon?(text)
    validator = text.match?(/^\s*(\w+(-?\w+){0,3}):\S[\s\S]+\S;?\s*$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Missing space after'\
      ' the colon in the declaration'
    end

    validator
  end

  def whitespace_colon?(text)
    validator = text.match?(/^[\s\S]+\s*:\s+[\s\S]+$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' in pseudo-class after the colon'
    end

    validator
  end

  def missing_space_before_brac?(text)
    validator = text.match?(/^\s*\S[\S\s]+\S\{\s*$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Expected one space before \'{\''
    end

    validator
  end

  def extras_space_before_selector?(text)
    validator = text.match?(/^\s+\S[\S\s]+\S\s*\{\s*$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace before selector'
    end

    validator
  end

  def whitespace_after_brac?(text)
    validator = text.match?(/^\s*\S[\S\s]+\S\s?\{\s+$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Expected new line after \'{\''
    end

    validator
  end

  def whitespace_end_line?(text)
    validator = text.match?(/^\s*\S[\S\s]+\S\s+$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' at end of line'
    end

    validator
  end

  def extras_whitespace_before_brac?(text)
    validator = text.match?(/^\s*\S[\S\s]+\S\s{2,}\{$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' before \'{\' only one space is allowed'
    end

    validator
  end

  def whitespace_after_end_brac?(text)
    validator = text.match?(/^\s*}\s+$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' after \'}\''
    end

    validator
  end

  def whitespace_before_end_brac?(text)
    validator = text.match?(/^\s+}\s*$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace before \'}\''
    end

    validator
  end

  private

  def handle_empty_lines
    @index += 1 if @file[@index].match?(/^\s*$/)

    while @file[@index].match?(/^\s*$/) && @index < @file.length
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected empty line,'\
      ' expected only one empty line'
      @index += 1
    end
  end

  def check_declarations
    while !@file[@index].include?('}') && @index < @file.length
      if declaration?(@file[@index])
        missing_space_after_colon?(@file[@index])
        whitespace_after_colon?(@file[@index])
        missing_semi_colon?(@file[@index])
        whitespace_declaration_end_line?(@file[@index])
      elsif unknown_word?(@file[@index])
        @error_output << format(
          '%-11<line>s', line: "line: #{@index + 1} "
        ).colorize(:light_black) + 'x'.colorize(:red) + '  Unknown word'
      end

      @index += 1
    end
  end

  def check_selector_end
    if end_selector?(@file[@index])
      whitespace_after_end_brac?(@file[@index])
      whitespace_before_end_brac?(@file[@index])
    elsif unknown_word?(@file[@index])
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unknown word'
    end
  end

  def check_selector
    if selector?(@file[@index])
      whitespace_colon?(@file[@index])
      missing_space_before_brac?(@file[@index])
      whitespace_after_brac?(@file[@index])
      whitespace_end_line?(@file[@index])
      extras_whitespace_before_brac?(@file[@index])
      extras_space_before_selector?(@file[@index])

      @index += 1

      check_declarations

      check_selector_end
    elsif invalid?(@file[@index])
      @index += 1

      check_declarations

      check_selector_end
    elsif unknown_word?(@file[@index])
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unknown word'

      @index += 1
    end
  end

  def invalid?(text)
    validator = text.match?(/^\s*(\S)+\s\{$/)

    if validator
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Invalid selector go'\
      ' learn some CSS bro O.o'
    end

    validator
  end
end
# rubocop:enable Metrics/ClassLength
