# frozen_string_literal: true

require 'optparse'

module UHaul
  # Used when interacting with the library from the command line interface (CLI).
  #
  # Usage:
  #
  #   cli = UHaul::CLI.new
  #   cli.parse
  class CLI
    module Code
      OK = 0
      ERROR = 1
    end

    # @param argv [Array<String>]
    def parse(argv = ARGV)
      parser.parse!(argv)
      command = argv.shift

      case command
      when 'crawl' then crawl(*argv)
      else
        warn("unsupported command=#{command.inspect}")
        exit(Code::ERROR)
      end
    end

    private

    # @param url [String] optional
    def crawl(url = nil)
      Crawl.run(url: url)
      exit(Code::OK)
    end

    def help(options)
      puts(options)
      exit(Code::OK)
    end

    def version
      puts(VERSION)
      exit(Code::OK)
    end

    # @return [OptionParser]
    def parser
      OptionParser.new do |options|
        options.banner = 'usage: uhaul [options] <command> [<args>]'

        options.on('-h', '--help', 'help') { help(options) }
        options.on('-v', '--version', 'version') { version }

        options.separator <<~COMMANDS
          commands:
            crawl [url]
        COMMANDS
      end
    end
  end
end
