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

      while /^\s*$/ === @file[@index]
        @error_output << "line:#{@index + 1} x Unexpected empty line, expected only one empty line"
        @index += 1
      end

      unless is_selector?(@file[@index])
        self.check_for_selector()
        index += 1
      end

      # check for declaration
      # missing space after colon
      # missing semi-colon
      # Unexpected whitespace end line

      # valid_selector and invalid_selector

    end
  end

  def is_selector?(text)
    /^((((\s?\*|\s?(\.|#)?(\w+(-*_*\w+)?)+)+|(:\w+))(:\w+)?(\s(>|,|\+|~)\s)?(\*\s)?)+)\s\{$/ === text
  end

  def is_whitespace_colon?(text)
    /^((((\s?\*|\s?(\.|#)?(\w+(-*_*\w+)?)+)+|(:\s+\w+))(:\s+\w+)?(\s(>|,|\+|~)\s)?(\*\s)?)+)\s*\{\s*$/ === @text
  end

  def missing_space_before_brac?(text)
    /^\S[\S\s]+\S\{\s*$/ === text
  end

  def whitespace_after_brac?(text)
    /^\S[\S\s]+\S\s?\{\s+$/ === text
  end

  def whitespace_end_line?(text)
    /^\S[\S\s]+\S\s+$/ === text
  end

  def extras_whitespace_before_brac?(text)
    /^\S[\S\s]+\S\s{2,}\{$/ === text
  end

  def is_invalid?(text)
    /^(\S)+\s\{$/ === text
  end

  def check_for_selector
    if is_whitespace_colon?(@file[@index])
      @error_output << "line:#{@index + 1} x Unexpected whitespace in pseudo-class after colon"
    end

    if missing_space_before_brac?(@file[@index])
      @error_output << "line:#{@index + 1} x Expected one space before '{'"
    end

    if whitespace_after_brac?(@file[@index])
      @error_output << "line:#{@index + 1} x Expected new line after '{'"
    end

    if whitespace_end_line?(@file[@index])
      @error_output << "line:#{@index + 1} x Unexpected whitespace at end of line"
    end

    if extras_whitespace_before_brac?(@file[@index])
      @error_output << "line:#{@index + 1} x Unexpected whitespace before '{' only one space is allowed"
    end

    if is_invalid?(@file[@index])
      @error_output << "line:#{@index + 1} x Invalide selector go learn some CSS bro O.o"
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