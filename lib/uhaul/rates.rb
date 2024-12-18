# frozen_string_literal: true

module UHaul
  # The rates (street + web) for a facility
  class Rates
    RATE_REGEX = /\$(?<price>[\d\.\,]+) Per Month/

    # @attribute [rw] rate
    #   @return [Integer]
    attr_accessor :price

    alias street price
    alias web price

    # @param text [String]
    #
    # @return [Rates]
    def self.parse(text:)
      price = Float(RATE_REGEX.match(text)[:price].gsub(',', ''))

      new(price:)
    end

    # @param street [Integer]
    # @param web [Integer]
    def initialize(price:)
      @price = price
    end

    # @return [String]
    def inspect
      "#<#{self.class.name} price=#{@price.inspect}>"
    end

    # @return [String] e.g. "$80"
    def text
      "$#{@price}"
    end
  end
end
