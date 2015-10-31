# encoding: utf-8
require 'erb'
require 'fileutils'
require 'lknovel/image'
require 'lknovel/meta'
require 'lknovel/utils'
require 'nokogiri'

module Lknovel
  class Chapter
    include ERBRender

    attr_reader :url, :title, :content

    def initialize(url, options = {})
      options = {:title => nil}.merge(options)
      @url = url
      @title = options[:title]
    end

    def parse
      page = retryable do
        Nokogiri::HTML(openuri(@url))
      end

      js = page.css('script').sort_by { |x| x.text.length }[-1].text

      @title = js.match(/subTitle:"([^"]+)"/)[1]

      @content = js.scan(/content:"([^"]+)"/).map do |x|
        if x[0] == '<br>'
          ''
        elsif x[0].start_with?('[img]')
          Image.new(URI.join(url, x[0][5..-7]))
        else
          x[0].strip.sub(/^　+/, '')
        end
      end
    end

  end
end
