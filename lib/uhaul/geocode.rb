# frozen_string_literal: true

module UHaul
  # The geocode (latitude + longitude) of a facility.
  class Geocode
    LATITUDE_REGEX = /\\u0022lat\\u0022:(?<latitude>[\+\-\d\.]+)/
    LONGITUDE_REGEX = /\\u0022long\\u0022:(?<longitude>[\+\-\d\.]+)/

    # @attribute [rw] latitude
    #   @return [Float]
    attr_accessor :latitude

    # @attribute [rw] longitude
    #   @return [Float]
    attr_accessor :longitude

    # @param latitude [Float]
    # @param longitude [Float]
    def initialize(latitude:, longitude:)
      @latitude = latitude
      @longitude = longitude
    end

    # @return [String]
    def inspect
      props = [
        "latitude=#{@latitude.inspect}",
        "longitude=#{@longitude.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String]
    def text
      "#{@latitude},#{@longitude}"
    end

    # @param document [String]
    # @param data [Hash] optional
    #
    # @return [Address]
    def self.parse(document:, data:)
      parse_by_data(data:) || parse_by_document(document:)
    end

    # @param data [Hash]
    #
    # @return [Address]
    def self.parse_by_data(data:)
      coordinates = data&.dig('areaServed', 'geoMidpoint')
      return unless coordinates

      new(
        latitude: Float(coordinates['latitude']),
        longitude: Float(coordinates['longitude'])
      )
    end

    # @param document [Nokogiri::HTML::Document]
    #
    # @return [Address]
    def self.parse_by_document(document:)
      document.text.match(/latitude:\s*(?<latitude>[\+\-\d\.]+),\s*longitude:\s*(?<longitude>[\+\-\d\.]+)/) do |match|
        new(
          latitude: Float(match[:latitude]),
          longitude: Float(match[:longitude])
        )
      end
    end
  end
end
