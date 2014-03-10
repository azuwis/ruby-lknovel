require_relative 'minitest_helper'
require 'lknovel/image'

describe Lknovel::Image do

  it 'lknovel image' do
    image = Lknovel::Image.new('http://lknovel.lightnovel.cn/illustration/image/20120808/20120808202600_62961.jpg')
    image.file.must_equal '20120808202600_62961.jpg'
  end

end
