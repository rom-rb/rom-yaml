# encoding: utf-8

if RUBY_ENGINE == 'rbx'
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'rom-yaml'

begin
  require 'byebug'
rescue LoadError
end

root = Pathname(__FILE__).dirname

Dir[root.join('shared/*.rb').to_s].each { |f| require f }

module Test
  def self.remove_constants
    constants.each(&method(:remove_const))
  end
end

RSpec.configure do |config|
  config.after do
    Test.remove_constants
  end

  config.disable_monkey_patching!
end
