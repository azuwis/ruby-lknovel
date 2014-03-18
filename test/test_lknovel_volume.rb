# encoding: utf-8
require 'minitest_helper'
require 'lknovel/volume'

describe Lknovel::Volume do

  volume = Lknovel::Volume.new('http://lknovel.lightnovel.cn/main/book/2136.html')
  volume.parse
  volume.chapters[0].parse
  cover_image = volume.chapters[0].content.find { |x| x.is_a?(Lknovel::Image) }
  volume.cover_image = cover_image

  it 'get path' do
    volume.path.must_equal '打工吧！魔王大人 - 短篇01 - 短篇01'
  end

  it 'get author' do
    volume.author.must_equal '和原聪司'
  end

  it 'get illustrator' do
    volume.illustrator.must_equal '029'
  end

  it 'get publisher' do
    volume.publisher.must_equal '电击文库'
  end

  it 'get date' do
    volume.date.must_equal '2012-08-17 21:02:34'
  end

  it 'get intro' do
    volume.intro.must_match /『拼死工作吧！魔王陛下！』/
  end

  it 'get cover image' do
    volume.cover_image.file.must_equal '20120817210516_51962.jpg'
  end

  it 'generate front html' do
    html = volume.render(File.join(Lknovel::TEMPLATE_PATH, 'front.html.erb'))
    html.must_match '<li><a href="000.html">第0章 序章</a></li>'
  end

end
