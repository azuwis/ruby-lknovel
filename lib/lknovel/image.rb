require 'lknovel/utils'
require 'uri'

module Lknovel
  class Image

    attr_reader :file

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

  end
end
