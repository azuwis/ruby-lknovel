# Lknovel

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

    $ lknovel http://lknovel.lightnovel.cn/main/book/2136.html

## Contributing

1. Fork it ( http://github.com/azuwis/lknovel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
