require 'codeclimate-test-reporter'
require 'simplecov'

def fixture_pathname(name)
  File.expand_path(File.join('fixtures', name), File.dirname(__FILE__))
end

CodeClimate::TestReporter.start
SimpleCov.start

require 'edst'
require 'edst/document'
