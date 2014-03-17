# encoding: utf-8
require 'erb'
require 'fileutils'
require 'lknovel/image'
require 'lknovel/meta'
require 'lknovel/utils'
require 'nokogiri'
require 'open-uri'

module Lknovel
  class Chapter

    attr_reader :url, :title, :content

    def initialize(url, options = {})
      @options = {:title => nil}.merge(options)
      @url = url
      @title = @options[:title]
    end

    def parse
      page = retryable do
        Nokogiri::HTML(open(@url))
      end

      @title = page.css('li.active')[0].text.sub('章', '章 ').strip

      @content = []
      page.css('div#J_view').css('div.lk-view-line, br + br').each do |x|
        img = x.css('img[data-cover]')
        if x.name == 'br'
          @content << ''
        elsif img.length > 0
          lk_image = Image.new(URI.join(url, img[0]['data-cover']))
          @content << lk_image
        else
          # strip and remove leading wide space
          @content << x.text.strip.sub(/^　+/, '')
        end
      end
    end

    def html(erb, path = nil)
      template = erb.is_a?(ERB) ? erb : ERB.new(File.read(erb), nil, '-')
      html_content = template.result(binding)
      if path.nil?
        html_content
      else
        if !File.exists?(path)
          File.open(path, 'w') do |file|
            file.puts html_content
          end
        end
      end
    end

  end
end
