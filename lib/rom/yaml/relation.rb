require 'rom/memory'

module ROM
  module YAML
    # YAML-specific relation subclass
    #
    # @api private
    class Relation < ROM::Memory::Relation
      adapter :yaml
    end
  end
end
