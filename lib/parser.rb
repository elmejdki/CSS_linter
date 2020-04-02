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

      break

    end
  end

  # def is_selector
  #   //
  # end

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