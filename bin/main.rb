require './lib/parser'
require 'colorize'

file_name = ARGV[0]

puts 'Please introduce the path of the file in the Terminal'.red unless file_name

unless File.exist?(file_name)
  puts 'There is no such file'.red
  exit
end

parser = Parser.new(file_name)
parser.lunch_linter
parser.print_results
