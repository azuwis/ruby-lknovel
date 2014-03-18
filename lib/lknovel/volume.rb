# encoding: utf-8
require 'lknovel/chapter'
require 'lknovel/meta'
require 'lknovel/utils'
require 'nokogiri'
require 'open-uri'

module Lknovel
  class Volume

    attr_reader :url, :series, :author, :title, :number_s, :number, :date,
      :illustrator, :publisher, :intro, :chapters, :path

    attr_accessor :cover_image

    def initialize(url)
      @url = url
      parse
    end

    def parse
      page = retryable do
        Nokogiri::HTML(open(@url))
      end

      page_title = page.title.split(' - ')
      @series = page_title[0]
      @number_s = page_title[1]
      if /第(?<number>[.\d]+)卷/ =~ page_title[1]
        @number = number.to_f
      end

      @intro = page.css('strong:contains("内容简介") + p').text

      page.css('table.lk-book-detail td').each_slice(2) do |x|
        case x[0].text
        when /标 *题/
          @title = x[1].text.strip
        when /作 *者/
          @author = x[1].text.strip
        when /插 *画/
          @illustrator = x[1].text.strip
        when /文 *库/
          @publisher = x[1].text.strip
        when /更 *新/
          @date = x[1].text.strip
        end
      end

      @path = "#{@series} - #{@number_s} - #{@title}"

      @chapters = page.css('ul.lk-chapter-list li.span3').map do |x|
        chapter_title = x.text.strip.sub(/\s+/, ' ')
        chapter_url = URI.join(url, x.css('a')[0]['href']).to_s
        Chapter.new(chapter_url, title: chapter_title)
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
