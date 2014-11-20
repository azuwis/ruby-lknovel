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

      @title = page.css('li.active')[0].text.sub('章', '章 ').strip

      @content = page.css('div#J_view')
      .css('div.lk-view-line, br + br')
      .map do |x|
        img = x.css('img[data-cover]')
        if x.name == 'br'
          ''
        elsif img.length > 0
          Image.new(URI.join(url, img[0]['data-cover']))
        else
          # strip and remove leading wide space
          x.text.strip.sub(/^　+/, '')
        end
      end
    end

  end
end
