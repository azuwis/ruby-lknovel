# encoding: utf-8
require 'parallel'

# http://blog.codefront.net/2008/01/14/retrying-code-blocks-in-ruby-on-exceptions-whatever/
# Options:
# * :tries - Number of retries to perform. Defaults to 3.
# * :on - The Exception on which a retry will be performed. Defaults to Exception, which retries on any Exception.
#
# Example
# =======
#   retryable(:tries => 1, :on => OpenURI::HTTPError) do
#     # your code here
#   end

def retryable(options = {}, &block)
  opts = { :tries => 3, :on => Exception }.merge(options)

  retry_exception, retries = opts[:on], opts[:tries]

  begin
    return yield
  rescue retry_exception
    retry if (retries -= 1) > 0
  end

  yield
end

def parallel_verbose(items, options = {}, &block)
  opts = {:title => 'Working', :verbose => true, :threads => 5}.merge(options)
  if opts[:verbose]
    progress = 1
    msg = "\r#{opts[:title]}: 0/#{items.size} ..."
    STDERR.write msg
  end
  Parallel.each(items, :in_threads => 5) do |item|
    extra_msg = block.call(item)
    if opts[:verbose]
      # get previous console output length, aware of wide chars
      size =
        msg.gsub(/\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/, '  ').size - 1
      STDERR.write "\r#{' ' * size}"
      msg =  "\r#{opts[:title]}: #{progress}/#{items.size} #{extra_msg}"
      STDERR.write msg
      progress = progress + 1
    end
  end
  if opts[:verbose]
    puts
  end
end
