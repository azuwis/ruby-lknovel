require 'lknovel/utils'
require 'open-uri'
require 'uri'

module Lknovel
  class Image

    attr_reader :uri, :file

    def initialize(url)
      @uri = URI(url)
      @file = @uri.path.split('/').last
    end

    def download(dir = '.')
      file = File.join(dir, @file)
      if !File.exists?(file)
        File.open(file, 'wb') do |w|
          retryable do
            open(@uri, 'rb') do |r|
              w.write(r.read)
            end
          end
        end
      end
    end

    def crop(output, operation, options = { :dir => '.' })
      input = File.join(options[:dir], @file)
      begin
        dim = IO.popen(['identify', '-format', '%[fx:w] %[fx:h]', input])
        dim = dim.gets.split
        width = dim[0].to_i
        height = dim[1].to_i
      rescue Exception
        width = 0
        height = 0
      end
      need_crop = true
      need_crop = yield(width, height) if block_given?
      cropped = false
      if need_crop
        success = system('convert', input, '-crop', operation, output)
        if success and File.exists?(output)
          cropped = true
        end
      end
      cropped
    end

  end
end
