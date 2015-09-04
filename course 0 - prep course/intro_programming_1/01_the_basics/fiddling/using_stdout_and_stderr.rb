# Some basic IO
$stdout.puts 'Tell me something at STDIN:'

input = gets.chomp

if input == ""
  # puts by default prints to STDOUT
  $stdout.puts "C'mon, man, anything will do."
  # it is possible to print to STDERR
  $stderr.puts "Alert! Someone did not enter anything at #{Time.now}!!"
else
  $stdout.puts "I knew that already."
end
