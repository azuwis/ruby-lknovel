# Lknovel
[![Build Status](https://travis-ci.org/azuwis/ruby-lknovel.png)](https://travis-ci.org/azuwis/ruby-lknovel)

Generate epub from http://lknovel.lightnovel.cn/

## Installation

Install using gem:

    $ gem install lknovel

Or add this line to your application's Gemfile:

    gem 'lknovel'

And then execute:

    $ bundle

## Dependencies

* Ruby 1.9
* [nokogiri](http://nokogiri.org/)
* [gepub](https://github.com/skoji/gepub)
* [parallel](https://github.com/grosser/parallel)

Rubygems will solve it for you.

If you encounter compiling/installing problem about nokogiri, install it
manually using the package manager. For Debian/Ubuntu:

    # apt-get install ruby-nokogiri

## Usage

    $ lknovel -h
    Usage: lknovel [options] url

    Specific options:
        -k, --[no-]keep                  Keep temporary files
        -q, --[no-]quiet                 Run quietly

    Common options:
        -h, --help                       Show this message
        -V, --version                    Show version

    $ lknovel http://lknovel.lightnovel.cn/main/book/2123.html
    Chapters: 5/5 第3章 魔王和勇者，在笹塚相会。
    Images: 13/13 20120817193746_95414.jpg
    Finish: 打工吧！魔王大人 - 第01卷 - 第1卷.epub

## Contributing

1. Fork it ( http://github.com/azuwis/lknovel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
