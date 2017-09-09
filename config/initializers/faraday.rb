# frozen_string_literal: true

Faraday::Utils.default_uri_parser = Addressable::URI.method(:parse)
