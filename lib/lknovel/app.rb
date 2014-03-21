require 'erb'
require 'fileutils'
require 'gepub'
require 'lknovel/series'
require 'lknovel/volume'
require 'optparse'
require 'ostruct'

module Lknovel
  class App

    def self.parse(args)
      options = OpenStruct.new
      options.verbose = true
      options.chapter_theads = 4
      options.image_theads = 5
      options.keep = false

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: lknovel [options] URL ...\n\n"
        opts.banner << "URL can be:\n"
        opts.banner << "    http://lknovel.lightnovel.cn/main/vollist/?.html\n"
        opts.banner << "    http://lknovel.lightnovel.cn/main/book/?.html\n"
        opts.separator "\nSpecific options:"

        opts.on('-k', '--[no-]keep', 'Keep temporary files') do |k|
          options.keep = k
        end

        opts.on('-t', '--chapter-theads THREADS', Integer,
                "Chapter download threads(#{options.chapter_theads})") do |ct|
          options.chapter_theads = ct
        end

        opts.on('-T', '--image-theads THREADS', Integer,
                "Image download threads(#{options.image_theads})") do |it|
          options.image_theads = it
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
        if url.start_with?('http://lknovel.lightnovel.cn/main/book/')
          volume = Volume.new(url)
          process_volume(volume)
        elsif url.start_with?('http://lknovel.lightnovel.cn/main/vollist/')
          series = Series.new(url)
          series.parse
          series.volumes.each do |volume|
            process_volume(volume)
          end
        else
          puts "Unsupported url: #{url}"
        end
      end
    end

    def process_volume(volume)
      volume.parse
      if File.exists?("#{volume.path}.epub")
        puts "Skip: #{volume.path}.epub"
        puts
        return
      end
      puts "Start: #{volume.title}"

      parallel_verbose(volume.chapters,
                       title: 'Chapters',
                       threads: @options.chapter_theads,
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

          parallel_verbose(images,
                           title: 'Images',
                           threads: @options.image_theads,
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
          if volume.cover_image
            cover_image = File.join(IMAGE_DIR, volume.cover_image)
            cover_image cover_image
          else
            cover_image = nil
          end
          file \
            "#{STYLESHEET_DIR}/default.css" => "#{STYLESHEET_PATH}/default.css"
          images = Dir.glob("#{IMAGE_DIR}/*").select {|x| x != cover_image}
          files *images
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
      puts

    end

  end
end
