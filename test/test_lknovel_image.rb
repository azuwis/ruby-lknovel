require_relative 'minitest_helper'
require 'lknovel/image'

describe Lknovel::Image do

  TMP = 'test/tmp'

  FileUtils.mkdir_p TMP

  image = Lknovel::Image.new('http://lknovel.lightnovel.cn/illustration/image/20120808/20120808202600_62961.jpg')

  it '@file' do
    image.file.must_equal '20120808202600_62961.jpg'
  end

  it 'download and crop' do
    image.download(TMP)
    File.exists?(File.join(TMP, image.file)).must_equal true
    cover_image = File.join(TMP, 'cover.jpg')
    cropped = image.crop(cover_image, '52%x100%+0+0', :dir => TMP) { |w, h| w > h * 1.5 }
    cropped.must_equal true
    File.exists?(cover_image).must_equal true
  end

end
