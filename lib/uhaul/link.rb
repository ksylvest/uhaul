# frozen_string_literal: true

module UHaul
  # A link in a sitemap.
  class Link
    # @attribute [rw] loc
    #   @return [String]
    attr_accessor :loc

    # @param loc [String]
    # @param lastmod [String, nil]
    def initialize(loc:)
      @loc = loc
    end

    # @return [String]
    def inspect
      "#<#{self.class.name} loc=#{@loc.inspect}>"
    end
  end
end
