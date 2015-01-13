require 'rom/adapter/memory/dataset'

module ROM
  module YAML
    class Dataset < ROM::Adapter::Memory::Dataset
      def self.row_proc
        # TODO: this is not recursive
        Transproc(:symbolize_keys)
      end
    end
  end
end