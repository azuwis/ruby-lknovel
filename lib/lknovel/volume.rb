# encoding: utf-8
require 'lknovel/chapter'
require 'lknovel/meta'
require 'lknovel/utils'
require 'nokogiri'

module Lknovel
  class Volume
    include ERBRender

    attr_reader :url, :series, :author, :title, :number, :date,
      :illustrator, :publisher, :intro, :chapters, :path

    attr_accessor :cover_image

    def initialize(url, options = {})
      options = {:title => nil}.merge(options)
      @url = url
      @title = options[:title]
    end

    def parse
      page = retryable do
        Nokogiri::HTML(openuri(@url))
      end

      @series = page.css('div.linovel-info h1').text
      @intro = page.css('p.linovel-info-desc').text

      @title = page.css('ul.linovel-book-list h3').text
      if /第(?<number>[.\d]+)卷/ =~ @title
        @number = number.to_f
      end

      page.css('div.linovel-info label').each do |x|
        case x.text.strip
        when '作者：'
          @author = x.next.text.strip
        when '插画：'
          @illustrator = x.next.text.strip
        when '文库：'
          @publisher = x.next.text.strip
        when '最新更新：'
          @date = x.next.text.strip
        end
      end

      @path = "#{@series} - #{@title}"

      @chapters = page.css('div.linovel-chapter-list a').map do |x|
        chapter_title = x.text.strip
        chapter_url = URI.join(url, x['href']).to_s
        Chapter.new(chapter_url, title: chapter_title)
      end
    end

  end
end
