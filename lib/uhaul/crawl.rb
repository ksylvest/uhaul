# frozen_string_literal: true

module UHaul
  # Handles the crawl command via CLI.
  class Crawl
    def self.run(...)
      new(...).run
    end

    # @param stdout [IO] optional
    # @param stderr [IO] optional
    # @param url [String] optional
    def initialize(stdout: $stdout, stderr: $stderr, url: nil)
      @stdout = stdout
      @stderr = stderr
      @url = url
    end

    def run
      if @url
        process(url: @url)
      else
        sitemap = Facility.sitemap
        @stdout.puts("count=#{sitemap.links.count}")
        @stdout.puts
        sitemap.links.each { |link| process(url: link.loc) }
      end
    end

    def process(url:)
      @stdout.puts(url)
      facility = Facility.fetch(url: url)
      @stdout.puts(facility.text)
      facility.prices.each { |price| @stdout.puts(price.text) }
      @stdout.puts
    rescue UHaul::Error => e
      @stderr.puts("url=#{url} error=#{e.message}")
    end
  end
end
