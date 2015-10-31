require 'parallel'
require 'open-uri'

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

def openuri(name, *rest, &block)
  open(name, *rest, {'User-Agent' => 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)'}, &block)
end

def parallel_verbose(items, options = {}, &block)
  opts = {:title => 'Working', :verbose => true, :threads => 5}.merge(options)
  if opts[:verbose]
    progress = 1
    msg = "\r#{opts[:title]}: 0/#{items.size} ..."
    STDERR.write msg
  end
  Parallel.each_with_index(items,
                           :in_threads => opts[:threads]) do |item, index|
    extra_msg = block.call(item, index)
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

module ERBRender
    def render(erb, path = nil)
      template = erb.is_a?(ERB) ? erb : ERB.new(File.read(erb), nil, '-')
      html_content = template.result(binding)
      if path.nil?
        html_content
      else
        if !File.exists?(path)
          File.open(path, 'w') do |file|
            file.puts html_content
          end
        end
      end
    end
end
