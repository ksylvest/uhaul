# frozen_string_literal: true

module UHaul
  # The dimensions (width + depth + sqft) of a price.
  class Dimensions
    DIMENSIONS_REGEX = /(?<width>[\d\.]+)'\s*x\s*(?<depth>[\d\.]+)'\s*x\s*(?<height>[\d\.]+)'/

    # @attribute [rw] depth
    #   @return [Float]
    attr_accessor :depth

    # @attribute [rw] width
    #  @return [Float]
    attr_accessor :width

    # @attribute [rw] height
    #   @return [Float]
    attr_accessor :height

    # @param depth [Float]
    # @param width [Float]
    # @param height [Float]
    def initialize(depth:, width:, height: DEFAULT_HEIGHT)
      @depth = depth
      @width = width
      @height = height
    end

    # @return [String]
    def inspect
      props = [
        "depth=#{@depth.inspect}",
        "width=#{@width.inspect}",
        "height=#{@height.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [Integer]
    def sqft
      Integer(@width * @depth)
    end

    # @return [Integer]
    def cuft
      Integer(@width * @depth * @height)
    end

    # @return [String] e.g. "10' × 10' (100 sqft)"
    def text
      "#{format('%g', @width)}' × #{format('%g', @depth)}' (#{sqft} sqft)"
    end

    # @param text [String]
    #
    # @return [Dimensions]
    def self.parse(text:)
      match = DIMENSIONS_REGEX.match(text)
      raise ParseError, "unknown length / width / height for #{text}" unless match

      width = Float(match[:width])
      depth = Float(match[:depth])
      height = Float(match[:height])
      new(depth:, width:, height:)
    end
  end
end
