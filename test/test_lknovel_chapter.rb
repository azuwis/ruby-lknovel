# encoding: utf-8
require_relative 'minitest_helper'
require 'lknovel/chapter'

describe Lknovel::Chapter do

  chapter = Lknovel::Chapter.new('http://www.linovel.com/n/view/1486.html')
  chapter.parse

  it 'get chapter title' do
    chapter.title.must_equal '序章'
  end

  it 'get chapter text' do
    chapter.content.must_include '变态王子与不笑猫'
  end

  it 'get chapter image' do
    chapter.content.find{|x| x.is_a? Lknovel::Image}.file.must_equal '20120808202600_62961.jpg'
  end

  it 'generate html' do
    html = chapter.render(File.join(Lknovel::TEMPLATE_PATH, 'chapter.html.erb'))
    html.must_match '"../stylesheets/default.css"'
    html.must_match '"../images/20120808202639_66681.jpg"'
  end

end
