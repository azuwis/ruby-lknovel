CI = !!ENV['TRAVIS']

if CI
  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'pry-rescue/minitest' unless CI
