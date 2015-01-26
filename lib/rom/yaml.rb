require 'yaml'

require 'rom'
require 'rom/yaml/version'
require 'rom/yaml/repository'

ROM.register_adapter(:yaml, ROM::YAML)
