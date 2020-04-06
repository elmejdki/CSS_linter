require 'colorize'
require_relative 'file_opener'
require_relative 'evaluator'

class Parser
  include Evaluator

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
        missing_space_after_colon?(@file[@index], @error_output, @index)
        whitespace_after_colon?(@file[@index], @error_output, @index)
        missing_semi_colon?(@file[@index], @error_output, @index)
        whitespace_declaration_end_line?(@file[@index], @error_output, @index)
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
      whitespace_after_end_brac?(@file[@index], @error_output, @index)
      whitespace_before_end_brac?(@file[@index], @error_output, @index)
    elsif unknown_word?(@file[@index])
      @error_output << format(
        '%-11<line>s', line: "line: #{@index + 1} "
      ).colorize(:light_black) + 'x'.colorize(:red) + '  Unknown word'
    end
  end

  def check_selector
    if selector?(@file[@index])
      whitespace_colon?(@file[@index], @error_output, @index)
      missing_space_before_brac?(@file[@index], @error_output, @index)
      whitespace_after_brac?(@file[@index], @error_output, @index)
      whitespace_end_line?(@file[@index], @error_output, @index)
      extras_whitespace_before_brac?(@file[@index], @error_output, @index)
      extras_space_before_selector?(@file[@index], @error_output, @index)

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
