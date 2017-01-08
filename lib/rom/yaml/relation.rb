require 'rom/memory'
require 'rom/plugins/relation/key_inference'

module ROM
  module YAML
    # YAML-specific relation subclass
    #
    # @api private
    class Relation < ROM::Memory::Relation
      adapter :yaml
      use :key_inference
    end
  end
end
