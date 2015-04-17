require 'rom/memory/dataset'

module ROM
  module YAML
    # YAML in-memory dataset used by YAML repositories
    #
    # @api public
    class Dataset < ROM::Memory::Dataset
      # Data-row transformation proc
      #
      # @api private
      def self.row_proc
        Transproc(:hash_recursion, Transproc(:symbolize_keys))
      end
    end
  end
end
