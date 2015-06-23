# encoding: utf-8
require 'minitest_helper'
require 'lknovel/series'

describe Lknovel::Series do

  series = Lknovel::Series.new('http://lknovel.lightnovel.cn/main/vollist/615.html')
  series.parse

  it 'volume[1]' do
    volume = series.volumes[1]
    volume.url.must_equal 'http://lknovel.lightnovel.cn/main/book/2123.html'
  end

end
