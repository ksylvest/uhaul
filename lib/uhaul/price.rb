# frozen_string_literal: true

module UHaul
  # The price (id + dimensions + rate) for a facility.
  class Price
    ID_REGEX = %r{(?<id>\d+)/(?:rent|reserve)/}
    PRICE_SELECTOR = '[data-unit-size="small"],[data-unit-size="medium"],[data-unit-size="large"]'

    # @attribute [rw] id
    #   @return [String]
    attr_accessor :id

    # @attribute [rw] dimensions
    #   @return [Dimensions]
    attr_accessor :dimensions

    # @attribute [rw] features
    #   @return [Features]
    attr_accessor :features

    # @attribute [rw] rates
    #   @return [Rates]
    attr_accessor :rates

    # @param id [String]
    # @param dimensions [Dimensions]
    # @param features [Features]
    # @param rates [Rates]
    def initialize(id:, dimensions:, features:, rates:)
      @id = id
      @dimensions = dimensions
      @features = features
      @rates = rates
    end

    # @return [String]
    def inspect
      props = [
        "id=#{@id.inspect}",
        "dimensions=#{@dimensions.inspect}",
        "features=#{@features.inspect}",
        "rates=#{@rates.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String] e.g. "123 | 5' × 5' (25 sqft) | $90"
    def text
      "#{@id} | #{@dimensions.text} | #{@rates.text} | #{@features.text}"
    end

    # @param element [Nokogiri::XML::Element]
    #
    # @return [Price]
    def self.parse(element:)
      id_element = element.at_css('form input[name="RentableInventoryPk"]')
      return unless id_element

      id = id_element['value']
      text = element.text.strip.gsub(/\s+/, ' ')

      dimensions = Dimensions.parse(text:)
      features = Features.parse(text:)
      rates = Rates.parse(text:)

      new(id:, dimensions:, features:, rates:)
    end
  end
end
