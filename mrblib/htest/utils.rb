class Htest
  module Utils
    ##
    # Open a file in a child process
    # with /promises/ applied and the
    # file opened with /mode/
    # @return [Integer]
    #  Returns pid
    def open_file(path:, promises:, mode:)
      Process.fork do
        jail.attach
        pledge("jail stdio #{promises}", nil)
        File.open(path, mode)
        exit(1)
      end
    end

    ##
    # @return (see Test::Utils#open_file)
    def read_file(path:, promises:)
      open_file(path:, promises:, mode: "r")
    end

    ##
    # @return (see Test::Utils#open_file)
    def write_file(path:, promises:)
      open_file(path:, promises:, mode: "w")
    end
  end
  include Utils
end
