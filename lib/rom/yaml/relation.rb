require 'rom/relation'

module ROM
  module YAML
    # YAML-specific relation subclass
    #
    # @api private
    class Relation < ROM::Relation
      adapter :yaml
      forward :join, :project, :restrict, :order
    end
  end
end
