require 'lknovel/volume'
require 'optparse'
require 'ostruct'
require 'pry'

module Lknovel
  class App

    attr_reader :options

    def self.parse(args)
      options = OpenStruct.new
      options.verbose = true
      options.keep = false

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: lknovel [options] url'
        opts.separator "\nSpecific options:"

        opts.on('-k', '--[no-]keep', 'Keep temporary files') do |v|
          options.verbose = v
        end

        opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
          options.verbose = v
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
     puts @options
     puts ARGV
    end

  end
end
