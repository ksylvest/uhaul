# frozen_string_literal: true

RSpec.describe UHaul::Facility do
  describe '.sitemap' do
    subject(:sitemap) { described_class.sitemap }

    around { |example| VCR.use_cassette('uhaul/facility/sitemap', &example) }

    it 'fetches and parses the sitemap' do
      expect(sitemap).to be_a(UHaul::Sitemap)
      expect(sitemap.links).to all(be_a(UHaul::Link))
    end
  end

  describe '.fetch' do
    subject(:fetch) { described_class.fetch(url: url) }

    let(:url) { 'https://www.uhaul.com/Locations/Self-Storage-near-Inglewood-CA-90301/712030/' }

    around { |example| VCR.use_cassette('uhaul/facility/fetch', &example) }

    it 'fetches and parses the facility' do
      expect(fetch).to be_a(described_class)
      expect(fetch.address).to be_a(UHaul::Address)
      expect(fetch.geocode).to be_a(UHaul::Geocode)
      expect(fetch.prices).to all(be_a(UHaul::Price))
    end
  end
end
