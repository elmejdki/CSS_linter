require './lib/parser'

file_name = ARGV[0]

puts 'Please introduce the directory of the file in the Terminal' unless file_name

unless File.exist?(file_name)
  puts 'There is no such file'
  exit
end

parser = Parser.new(file_name)
parser.lunch_linter
parser.print_results
