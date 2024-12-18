# frozen_string_literal: true

module UHaul
  # A facility (address + geocode + prices) on uhaul.com.
  #
  # e.g. https://www.uhaul.com/Locations/Self-Storage-near-Inglewood-CA-90301/712030/
  class Facility
    class ParseError < StandardError; end

    PRICES_SELECTOR = '#roomTypes > ul:not([id*="VehicleStorage"]) > li'

    SITEMAP_URLS = %w[
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-AL.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-AK.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-AZ.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-AR.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-CA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-CO.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-CT.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-DC.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-DE.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-FL.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-GA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-HI.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-ID.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-IL.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-IN.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-IA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-KS.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-KY.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-LA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-ME.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-MD.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-MA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-MI.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-MN.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-MS.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-MO.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-MT.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-NE.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-NV.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-NH.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-NJ.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-NM.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-NY.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-NC.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-ND.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-OH.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-OK.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-OR.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-PA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-RI.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-SC.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-SD.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-TN.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-TX.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-UT.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-VT.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-VA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-WA.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-WV.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-WI.ashx
      https://www.uhaul.com/Locations/Sitemaps/Sitemap-for-Storage-in-WY.ashx
    ].freeze

    DEFAULT_EMAIL = 'service@uhaul.com'
    DEFAULT_PHONE = '+1-800-468-4285'

    # @attribute [rw] id
    #   @return [String]
    attr_accessor :id

    # @attribute [rw] url
    #   @return [String]
    attr_accessor :url

    # @attribute [rw] name
    #   @return [String]
    attr_accessor :name

    # @attribute [rw] phone
    #   @return [String]
    attr_accessor :phone

    # @attribute [rw] email
    #   @return [String]
    attr_accessor :email

    # @attribute [rw] address
    #   @return [Address]
    attr_accessor :address

    # @attribute [rw] geocode
    #   @return [Geocode, nil]
    attr_accessor :geocode

    # @attribute [rw] prices
    #   @return [Array<Price>]
    attr_accessor :prices

    # @return [Sitemap]
    def self.sitemap
      links = sitemaps.map(&:links).reduce(&:+)
      Sitemap.new(links:)
    end

    # @return [Array<Sitemap>]
    def self.sitemaps
      SITEMAP_URLS.map do |url|
        Sitemap.fetch(url:)
      end
    end

    # @param url [String]
    #
    # @return [Facility]
    def self.fetch(url:)
      document = Crawler.html(url:)
      parse(url:, document:)
    end

    # @param url [String]
    # @param document [Nokogiri::HTML::Document]
    #
    # @return [Facility]
    def self.parse(url:, document:)
      data = parse_ld_json_script(document:)

      id = data['@id'].match(%r{(?<id>\d+)/#schema$})[:id]
      name = data['name']

      geocode = Geocode.parse(data: data['geo'])
      address = Address.parse(data: data['address'])
      prices = document.css(PRICES_SELECTOR).map { |element| Price.parse(element:) }.compact

      new(id:, url:, name:, address:, geocode:, prices:)
    end

    # @param document [Nokogiri::HTML::Document]
    #
    # @raise [ParseError]
    #
    # @return [Hash]
    def self.parse_ld_json_script(document:)
      parse_ld_json_scripts(document:).find do |data|
        data['@type'] == 'SelfStorage'
      end || raise(ParseError, 'missing ld+json')
    end

    # @param document [Nokogiri::HTML::Document]
    #
    # @return [Array<Hash>]
    def self.parse_ld_json_scripts(document:)
      elements = document.xpath('//script[@type="application/ld+json"]')

      elements.map { |element| element.text.empty? ? {} : JSON.parse(element.text) }
    end

    # @param id [String]
    # @param url [String]
    # @param name [String]
    # @param address [Address]
    # @param geocode [Geocode]
    # @param phone [String]
    # @param email [String]
    # @param prices [Array<Price>]
    def initialize(id:, url:, name:, address:, geocode:, phone: DEFAULT_PHONE, email: DEFAULT_EMAIL, prices: [])
      @id = id
      @url = url
      @name = name
      @address = address
      @geocode = geocode
      @phone = phone
      @email = email
      @prices = prices
    end

    # @return [String]
    def inspect
      props = [
        "id=#{@id.inspect}",
        "url=#{@url.inspect}",
        "address=#{@address.inspect}",
        "geocode=#{@geocode.inspect}",
        "phone=#{@phone.inspect}",
        "email=#{@email.inspect}",
        "prices=#{@prices.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String]
    def text
      "#{@id} | #{@name} | #{@phone} | #{@email} | #{@address.text} | #{@geocode ? @geocode.text : 'N/A'}"
    end
  end
end
