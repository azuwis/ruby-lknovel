# encoding: utf-8
require 'minitest_helper'
require 'lknovel/series'

describe Lknovel::Series do

  series = Lknovel::Series.new('http://linovel.com/n/vollist/615.html')
  series.parse

  it 'series' do
    series.volumes.find { |x| x.url == 'http://linovel.com/n/book/2123.html' }.title.must_equal '第01卷 第1卷'
  end

end
