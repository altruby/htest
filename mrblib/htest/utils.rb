class Htest
  module Utils
    ##
    # Open a file in a child process
    # with /promises/ applied and the
    # file opened with /mode/
    # @return [Integer]
    #  Returns pid
    def open_file(promises:, mode:)
      Process.fork do
        jail.attach
        pledge("jail stdio #{promises}", nil)
        File.open("/foobar.txt", mode)
        exit(1)
      end
    end

    ##
    # @return (see Test::Utils#open_file)
    def read_file(promises:)
      open_file(promises:, mode: "r")
    end

    ##
    # @return (see Test::Utils#open_file)
    def write_file(promises:)
      open_file(promises:, mode: "w")
    end

    ##
    # @param [Jail] jail
    # @return [void]
    def setup_jail(jail)
      file = File.join(jail.path, "foobar.txt")
      File.open(file, "w") { it.write "foobar" }
    end
  end
  include Utils
end
