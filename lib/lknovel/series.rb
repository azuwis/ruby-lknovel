# encoding: utf-8
require 'lknovel/utils'
require 'lknovel/volume'
require 'nokogiri'
require 'open-uri'

module Lknovel
  class Series
    attr_reader :volumes

    def initialize(url)
      @url = url
    end

    def parse
      page = retryable do
        Nokogiri::HTML(open(@url))
      end

      @volumes = page.css('dl dd h2.ft-24 strong a').map do |x|
        volume_title = x.text.split("\r\n")[-1].strip
        volume_url = x['href']
        Volume.new(volume_url, title: volume_title)
      end
    end
  end
end
