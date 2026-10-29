ENV["RUBY"] ||= "ruby34"
tests = []

def warn(m)
  $stderr.puts(m)
end

def help
  warn <<~HELP
  htest [options]

  Options:
    -h     show this help
  HELP
end

while option = ARGV.shift
  case option
  when "-h" then [help, exit(0)]
  else [help, exit(1)]
  end
end

Dir.foreach(Dir.getwd) do |file|
  next if File.directory?(file)
  next if not file.end_with?("_test.rb")
  tests << File.join(Dir.getwd, file)
end

Picotest::Runner.new(
  Dir.getwd,
  entries: tests
).run
