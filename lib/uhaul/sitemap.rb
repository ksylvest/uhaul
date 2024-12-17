# frozen_string_literal: true

module UHaul
  # A sitemap on uhaul.com.
  class Sitemap
    # @attribute [rw] links
    #   @return [Array<Link>]
    attr_accessor :links

    # @param document [NokoGiri::XML::Document]
    #
    # @return [Sitemap]
    def self.parse(document:)
      links = document.xpath('//xmlns:url').map do |url|
        loc = url.at_xpath('xmlns:loc').text
        Link.new(loc:)
      end

      new(links: links.filter { |link| link.loc.match(%r{/Self-Storage/.*/\d+}) })
    end

    # @param url [String]
    #
    # @return [Sitemap]
    def self.fetch(url:)
      document = Crawler.xml(url:)
      parse(document:)
    end

    # @param links [Array<Link>]
    def initialize(links:)
      @links = links
    end

    # @return [String]
    def inspect
      "#<#{self.class.name} links=#{@links.inspect}>"
    end
  end
end
