require './lib/parser'
require 'colorize'

file_path = ARGV[0]

puts 'Please introduce the path of the file in the Terminal'.red unless file_path

unless File.exist?(file_path)
  puts 'There is no such file'.red
  exit
end

parser = Parser.new(file_path)
parser.lunch_linter
parser.print_results
