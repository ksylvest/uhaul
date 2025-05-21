# frozen_string_literal: true

module UHaul
  # The address (street + city + state + zip) of a facility.
  class Address
    # @attribute [rw] street
    #   @return [String]
    attr_accessor :street

    # @attribute [rw] city
    #   @return [String]
    attr_accessor :city

    # @attribute [rw] state
    #   @return [String]
    attr_accessor :state

    # @attribute [rw] zip
    #   @return [String]
    attr_accessor :zip

    # @param street [String]
    # @param city [String]
    # @param state [String]
    # @param zip [String]
    def initialize(street:, city:, state:, zip:)
      @street = street
      @city = city
      @state = state
      @zip = zip
    end

    # @return [String]
    def inspect
      props = [
        "street=#{@street.inspect}",
        "city=#{@city.inspect}",
        "state=#{@state.inspect}",
        "zip=#{@zip.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String]
    def text
      "#{street}, #{city}, #{state} #{zip}"
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
      address = data&.dig('address')
      return unless address

      new(
        street: address['streetAddress'],
        city: address['addressLocality'],
        state: address['addressRegion'],
        zip: address['postalCode']
      )
    end

    # @param document [Nokogiri::HTML::Document]
    #
    # @return [Address]
    def self.parse_by_document(document:)
      element = document.at_css('address')
      return unless element

      element.text.match(/(?<street>.+)[\r\n,]+(?<city>.+)[\r\n,]+(?<state>.+)[\r\n\s,]+(?<zip>\d{5})/) do |match|
        new(
          street: strip(match[:street]),
          city: strip(match[:city]),
          state: strip(match[:state]),
          zip: strip(match[:zip])
        )
      end
    end

    # @param text [String]
    #
    # @return [String]
    def self.strip(text)
      return unless text

      text
        .strip
        .gsub(/^[\s\p{Space},],+/, '')
        .gsub(/[\s\p{Space},]+$/, '')
        .gsub(/[\s\p{Space}]+/, ' ')
    end
  end
end
