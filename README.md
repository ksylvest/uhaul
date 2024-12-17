# UHaul

[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ksylvest/uhaul/blob/main/LICENSE)
[![RubyGems](https://img.shields.io/gem/v/uhaul)](https://rubygems.org/gems/uhaul)
[![GitHub](https://img.shields.io/badge/github-repo-blue.svg)](https://github.com/ksylvest/uhaul)
[![Yard](https://img.shields.io/badge/docs-site-blue.svg)](https://uhaul.ksylvest.com)
[![CircleCI](https://img.shields.io/circleci/build/github/ksylvest/uhaul)](https://circleci.com/gh/ksylvest/uhaul)

## Installation

```bash
gem install uhaul
```

## Configuration

```ruby
require 'uhaul'

UHaul.configure do |config|
  config.user_agent = '../..' # ENV['UHAUL_USER_AGENT']
  config.timeout = 30 # ENV['UHAUL_TIMEOUT']
  config.proxy_url = 'http://user:pass@superproxy.zenrows.com:1337' # ENV['UHAUL_PROXY_URL']
end
```

## Usage

```ruby
require 'uhaul'

sitemap = UHaul::Facility.sitemap
sitemap.links.each do |link|
  url = link.loc
  facility = UHaul::Facility.fetch(url:)

  puts facility.text

  facility.prices.each do |price|
    puts price.text
  end

  puts
end
```

## CLI

```bash
uhaul crawl
```
