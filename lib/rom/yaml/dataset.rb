require 'rom/memory/dataset'

module ROM
  module YAML
    # YAML in-memory dataset used by YAML gateways
    #
    # @api public
    class Dataset < ROM::Memory::Dataset
      # Data-row transformation proc
      #
      # @api private
      def self.row_proc
        Transforms[:deep_symbolize_keys]
      end
    end


    # @api private
    class Transforms
      extend Transproc::Registry
      import Transproc::HashTransformations
      import Transproc::Recursion
    end
  end
end
