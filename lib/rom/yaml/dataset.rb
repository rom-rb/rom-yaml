require 'rom/memory/dataset'

module ROM
  module YAML
    # YAML in-memory dataset used by YAML gateways
    #
    # @api public
    class Dataset < ROM::Memory::Dataset
      option :dataset_name, reader: true
      option :path, reader: true
      option :mode, reader: true

      # Data-row transformation proc
      #
      # @api private
      def self.row_proc
        Transforms[:hash_recursion, Transforms[:symbolize_keys]]
      end

      # Source data should by symbolized for command purpose
      #
      # @api public
      def initialize(data, options)
        symbolized_data = data.map{ |d| self.class.row_proc.call(d) }
        super(symbolized_data, options)
      end

      # Synchronization dataset with file content
      #
      # @api public
      def sync!
        write_data && reload!
      end

      private

      # Write current dataset to file
      #
      # @api private
      def write_data
        case mode
          when :one  then write_data_with_single_dataset
          when :many then write_data_with_multiple_datasets
        end
      end

      # Write dataset to file used when one file has one dataset
      #
      # @api private
      def write_data_with_single_dataset
        content = { dataset_name => data }
        File.open(path, "w") { |f| f.write(JSON.pretty_generate(content)) }
        write_json_file(content)
      end

      # Write dataset to file used when one file has multiple datasets
      #
      # @api private
      def write_data_with_multiple_datasets
        content = Gateway.load_file(path)
        content[dataset_name] = data
        write_json_file(content)
      end

      def write_json_file(content)
        File.open(path, "w") do |f|
          f.write(JSON.pretty_generate(content))
        end
      end

      # Load data to datase
      #
      # @api private
      def reload!
        @data = Gateway.load_file(path).fetch(dataset_name.to_s)
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
