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

Dir.foreach(ENV["PWD"]) do |file|
  next if File.directory?(file)
  next if not file.end_with?("_test.rb")
  load File.join(ENV["PWD"], file)
end

ObjectSpace.each_object(Class) do |klass|
  next unless [Picotest::Test, Htest].any? { it == klass.superclass }
  t = klass.new
  t.list_tests.each do |m|
    tt = klass.new
    tt.setup
    tt.send(m)
  ensure
    tt.teardown
  end
end
