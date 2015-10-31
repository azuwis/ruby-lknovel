# encoding: utf-8
require 'lknovel/utils'
require 'lknovel/volume'
require 'nokogiri'

module Lknovel
  class Series
    attr_reader :volumes

    def initialize(url)
      @url = url
    end

    def parse
      page = retryable do
        Nokogiri::HTML(openuri(@url))
      end

      @volumes = page.css('li.linovel-book-item h3 a').map do |x|
        volume_title = x.text.strip
        volume_url = URI.join(@url, x['href']).to_s
        Volume.new(volume_url, title: volume_title)
      end
    end
  end
end
