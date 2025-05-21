# frozen_string_literal: true

RSpec.describe UHaul::Facility do
  describe '.sitemap' do
    subject(:sitemap) { described_class.sitemap }

    around { |example| VCR.use_cassette('uhaul/facility/sitemap', &example) }

    it 'fetches and parses the sitemap' do
      expect(sitemap).to be_a(UHaul::Sitemap)
      expect(sitemap.links).not_to be_empty
      expect(sitemap.links).to all(be_a(UHaul::Link))
    end
  end

  describe '.fetch' do
    subject(:fetch) { described_class.fetch(url: url) }

    context 'with facility ID 712030' do
      let(:url) { 'https://www.uhaul.com/Locations/Self-Storage-near-Inglewood-CA-90301/712030/' }

      around { |example| VCR.use_cassette('uhaul/facility/fetch_712030', &example) }

      it 'fetches and parses the facility' do
        expect(fetch).to be_a(described_class)
        expect(fetch.url).to eq(url)
        expect(fetch.id).to eql('712030')
        expect(fetch.name).to eql('U-Haul Moving & Storage of Inglewood')
        expect(fetch.address).to be_a(UHaul::Address)
        expect(fetch.address.street).to eql('964 S La Brea')
        expect(fetch.address.city).to eql('Inglewood')
        expect(fetch.address.state).to eql('CA')
        expect(fetch.address.zip).to eql('90301')
        expect(fetch.geocode).to be_a(UHaul::Geocode)
        expect(fetch.prices).not_to be_empty
        expect(fetch.prices).to all(be_a(UHaul::Price))
      end
    end

    context 'with facility ID 1026189' do
      let(:url) { 'https://www.uhaul.com/Locations/Self-Storage-near-Daphne-AL-36526/1026189/' }

      around { |example| VCR.use_cassette('uhaul/facility/fetch_1026189', &example) }

      it 'fetches and parses the facility' do
        expect(fetch).to be_a(described_class)
        expect(fetch.url).to eq(url)
        expect(fetch.id).to eql('1026189')
        expect(fetch.name).to eql('Main Street Self Storage, Llc | U-Haul')
        expect(fetch.address).to be_a(UHaul::Address)
        expect(fetch.address.street).to eql('28613 N. Main Street')
        expect(fetch.address.city).to eql('Daphne')
        expect(fetch.address.state).to eql('AL')
        expect(fetch.address.zip).to eql('36526')
        expect(fetch.geocode).to be_nil
        expect(fetch.prices).to be_empty
        expect(fetch.prices).to all(be_a(UHaul::Price))
      end
    end
  end
end
