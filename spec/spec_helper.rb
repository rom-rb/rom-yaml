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

ROM.use :auto_registration
