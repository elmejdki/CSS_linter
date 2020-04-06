require 'colorize'

module Evaluator
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

  def whitespace_declaration_end_line?(text, error_output, index)
    return false unless text.match?(/^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+\S;\s+$/)

    error_output << format(
      '%-11<line>s', line: "line: #{index + 1} "
    ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
    ' at end of the line of the declaration'

    true
  end

  def missing_semi_colon?(text, error_output, index)
    return false unless text.match?(/^\s*(\w+(-?\w+){0,3}):\s*\S[\s\S]+(\w|"|')\s*$/)

    error_output << format(
      '%-11<line>s', line: "line: #{index + 1} "
    ).colorize(:light_black) + 'x'.colorize(:red) + '  Missing simi-colon at'\
    ' the end of the declaration'

    true
  end

  def whitespace_after_colon?(text, error_output, index)
    return false unless text.match?(/^\s*(\w+(-?\w+){0,3}):\s{2,}\S[\s\S]+\S;?\s*$/)

    error_output << format(
      '%-11<line>s', line: "line: #{index + 1} "
    ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
    ' after the colon in the declaration, expected only one space'

    true
  end

  def missing_space_after_colon?(text, error_output, index)
    return false unless text.match?(/^\s*(\w+(-?\w+){0,3}):\S[\s\S]+\S;?\s*$/)

    error_output << format('%-11<line>s', line: "line: #{index + 1} ")
      .colorize(:light_black) + 'x'.colorize(:red) + '  Missing space after'\
      ' the colon in the declaration'

    true
  end

  def whitespace_colon?(text, error_output, index)
    return false unless text.match?(/^[\s\S]+\s*:\s+[\s\S]+$/)

    error_output << format('%-11<line>s', line: "line: #{index + 1} ")
      .colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' in pseudo-class after the colon'

    true
  end

  def missing_space_before_brac?(text, error_output, index)
    return false unless text.match?(/^\s*\S[\S\s]+\S\{\s*$/)

    error_output << format(
      '%-11<line>s', line: "line: #{index + 1} "
    ).colorize(:light_black) + 'x'.colorize(:red) + '  Expected one space before \'{\''

    true
  end

  def extras_space_before_selector?(text, error_output, index)
    return false unless text.match?(/^\s+\S[\S\s]+\S\s*\{\s*$/)

    error_output << format('%-11<line>s', line: "line: #{index + 1} ")
      .colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace before selector'

    true
  end

  def whitespace_after_brac?(text, error_output, index)
    return false unless text.match?(/^\s*\S[\S\s]+\S\s?\{\s+$/)

    error_output << format('%-11<line>s', line: "line: #{index + 1} ")
      .colorize(:light_black) + 'x'.colorize(:red) + '  Expected new line after \'{\''

    true
  end

  def whitespace_end_line?(text, error_output, index)
    return false unless text.match?(/^\s*\S[\S\s]+\S\s+$/)

    error_output << format('%-11<line>s', line: "line: #{index + 1} ")
      .colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace at end of line'

    true
  end

  def extras_whitespace_before_brac?(text, error_output, index)
    return false unless text.match?(/^\s*\S[\S\s]+\S\s{2,}\{$/)

    error_output << format('%-11<line>s', line: "line: #{index + 1} ")
      .colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace'\
      ' before \'{\' only one space is allowed'

    true
  end

  def whitespace_after_end_brac?(text, error_output, index)
    return false unless text.match?(/^\s*}\s+$/)

    error_output << format(
      '%-11<line>s', line: "line: #{index + 1} "
    ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace after \'}\''

    true
  end

  def whitespace_before_end_brac?(text, error_output, index)
    return false unless text.match?(/^\s+}\s*$/)

    error_output << format(
      '%-11<line>s', line: "line: #{index + 1} "
    ).colorize(:light_black) + 'x'.colorize(:red) + '  Unexpected whitespace before \'}\''

    true
  end
end
