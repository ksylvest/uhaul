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

    # @param data [Hash]
    #
    # @return [Geocode]
    def self.parse(data:)
      latitude = data[:latitude]
      longitude = data[:longitude]

      new(latitude:, longitude:)
    end

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
  end
end
