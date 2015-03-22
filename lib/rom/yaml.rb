require 'rom'

require 'rom/yaml/version'
require 'rom/yaml/repository'
require 'rom/yaml/relation'

ROM.register_adapter(:yaml, ROM::YAML)
