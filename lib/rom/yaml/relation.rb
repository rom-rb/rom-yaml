require 'rom/memory'
require 'rom/yaml/schema'

module ROM
  module YAML
    # YAML-specific relation subclass
    #
    # @api private
    class Relation < ROM::Memory::Relation
      adapter :yaml

      schema_class YAML::Schema

      option :output_schema, default: -> { schema.to_output_hash }
    end
  end
end
