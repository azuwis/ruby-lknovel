# Lknovel
[![Build Status](https://travis-ci.org/azuwis/ruby-lknovel.png)](https://travis-ci.org/azuwis/ruby-lknovel)
[![Coverage Status](https://coveralls.io/repos/azuwis/ruby-lknovel/badge.png)](https://coveralls.io/r/azuwis/ruby-lknovel)
[![Dependency Status](https://gemnasium.com/azuwis/ruby-lknovel.svg)](https://gemnasium.com/azuwis/ruby-lknovel)
[![Gem Version](https://badge.fury.io/rb/lknovel.png)](http://badge.fury.io/rb/lknovel)

Generate epub from http://www.linovel.com/

## Installation

Install using gem:

    $ gem install lknovel

Or add this line to your application's Gemfile:

    gem 'lknovel'

And then execute:

    $ bundle

## Dependencies

* [ruby >= 1.9](https://www.ruby-lang.org/en/installation/)
* [nokogiri](http://nokogiri.org/)
* [gepub](https://github.com/skoji/gepub)
* [parallel](https://github.com/grosser/parallel)

Rubygems will solve them for you.

If you encounter compiling/installing problem about nokogiri, install it
manually using the package manager.

For Debian/Ubuntu:

    # apt-get install ruby-nokogiri

## Usage

    $ lknovel -h
    Usage: lknovel [options] URL ...

    URL can be:
        http://www.linovel.com/n/vollist/?.html
        http://www.linovel.com/n/book/?.html

    Specific options:
        -k, --[no-]keep                  Keep temporary files
        -t, --chapter-theads THREADS     Chapter download threads(4)
        -T, --image-theads THREADS       Image download threads(5)
        -q, --[no-]quiet                 Run quietly

    Common options:
        -h, --help                       Show this message
        -V, --version                    Show version

    $ lknovel http://www.linovel.com/n/book/2123.html
    Chapters: 5/5 第3章 魔王和勇者，在笹塚相会。
    Images: 13/13 20120817193746_95414.jpg
    Finish: 打工吧！魔王大人 - 第01卷 第1卷.epub

## Contributing

1. Fork it ( https://github.com/azuwis/ruby-lknovel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
