require 'rom-core'

require 'rom/yaml/version'
require 'rom/yaml/gateway'
require 'rom/yaml/relation'

ROM.register_adapter(:yaml, ROM::YAML)
