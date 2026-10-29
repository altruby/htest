tests = []
while option = ARGV.shift
  case option
  when "-h"
    $stderr.puts <<-HELP
htest [options] first_test.rb second_test.rb

Options:
    -h     show this help
HELP
  exit 0
  else
    tests.push(option)
  end
end

ENV["RUBY"] ||= "ruby34"
Picotest::Runner.new(
  Dir.getwd,
  entries: tests.map { File.join(Dir.getwd, it) }
).run
