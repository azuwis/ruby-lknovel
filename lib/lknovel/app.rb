require 'erb'
require 'fileutils'
require 'gepub'
require 'lknovel/volume'
require 'optparse'
require 'ostruct'

module Lknovel
  class App

    def self.parse(args)
      options = OpenStruct.new
      options.verbose = true
      options.keep = false

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: lknovel [options] url'
        opts.separator "\nSpecific options:"

        opts.on('-k', '--[no-]keep', 'Keep temporary files') do |k|
          options.keep = k
        end

        opts.on('-q', '--[no-]quiet', 'Run quietly') do |q|
          options.verbose = !q
        end

        opts.separator "\nCommon options:"

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('-V', '--version', 'Show version') do
          puts VERSION
          exit
        end
      end

      begin
        opt_parser.parse!(args)
      rescue OptionParser::InvalidOption
        puts opt_parser
        exit
      end

      options
    end

    def initialize(args)
      @options = self.class.parse(args)
    end

    def run
      ARGV.each do |url|
        process_volume(url)
      end
    end

    def process_volume(url)
      volume = Volume.new(url)

      parallel_verbose(volume.chapters, title: 'Chapters',
                        verbose: @options.verbose) do |chapter|
        chapter.parse
        chapter.title
      end

      FileUtils.mkdir_p(volume.path)
      Dir.chdir(volume.path) do
        # download images
        FileUtils.mkdir_p(IMAGE_DIR)
        Dir.chdir(IMAGE_DIR) do
          images = []
          volume.chapters.each do |chapter|
            chapter.content.each do |content|
              images << content if content.is_a?(Image)
            end
          end

          parallel_verbose(images, title: 'Images',
                            verbose: @options.verbose) do |image|
            image.download
            image.file
          end

          if images.size > 0
            cover_image = images[0]
            # crop cover image if width > height * 1.4
            cropped = cover_image.crop('cover.jpg',
                                       '52%x100%+0+0') { |w, h| w > h * 1.4 }
            volume.cover_image = cropped ? 'cover.jpg' : cover_image.file
          end
        end

        # generate html
        FileUtils.mkdir_p(HTML_DIR)
        Dir.chdir(HTML_DIR) do
          volume.render(File.join(TEMPLATE_PATH, 'front.html.erb'), 'front.html')
          erb = File.read(File.join(TEMPLATE_PATH, 'chapter.html.erb'))
          template = ERB.new(erb, nil, '-')
          volume.chapters.each_with_index do |chapter, index|
            chapter.render(template, HTML_FILE_FORMAT % index)
          end
        end
      end

      builder = GEPUB::Builder.new {
        unique_identifier volume.url
        language 'zh'
        date Time.parse(volume.date + ' +0800')

        title "#{volume.series} - #{volume.number_s}"
        collection volume.title, volume.number

        creator volume.author
        publisher volume.publisher
        contributor volume.illustrator, 'ill'

        resources(:workdir => volume.path) {
          cover_image File.join(IMAGE_DIR, volume.cover_image)
          file \
            "#{STYLESHEET_DIR}/default.css" => "#{STYLESHEET_PATH}/default.css"
          glob "#{IMAGE_DIR}/*"
          ordered {
            nav "#{HTML_DIR}/front.html"
            volume.chapters.each_with_index do |chapter, index|
              file "#{HTML_DIR}/#{HTML_FILE_FORMAT}" % index
              heading chapter.title
            end
          }
        }
      }

      builder.generate_epub("#{volume.path}.epub")
      FileUtils.rm_r volume.path unless @options.keep
      puts "Finish: #{volume.path}.epub"

    end

  end
end
