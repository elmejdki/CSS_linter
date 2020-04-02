require './lib/parser'

file_name = ARGV[0]

puts 'Please introduce the directory of the file in the Terminal' unless file_name

unless File.exist?(file_name)
  puts 'There is no such file'
  exit
end

file = File.open(file_name)
file_data = file.readlines.map(&:chomp)
file.close

parser = Parser.new(file_data)
parser.lunch_linter
parser.print_results
