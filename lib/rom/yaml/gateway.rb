require 'yaml'

require 'rom/gateway'
require 'rom/yaml/dataset'
require 'rom/yaml/commands'

module ROM
  module YAML
    # YAML gateway
    #
    # Connects to a yaml file and uses it as a data-source
    #
    # @example
    #   rom = ROM.container(:yaml, '/path/to/data.yml')
    #   gateway = rom.gateways[:default]
    #   gateway[:users] # => data under 'users' key from the yaml file
    #
    # @api public
    class Gateway < ROM::Gateway
      adapter :yaml

      # @attr_reader [Hash] sources Data loaded from files
      #
      # @api private
      attr_reader :sources

      # @attr_reader [Hash] datasets YAML datasets from sources
      #
      # @api private
      attr_reader :datasets

      # Create a new yaml gateway from a path to file(s)
      #
      # @example
      #   gateway = ROM::YAML::Gateway.new('/path/to/files')
      #
      # @param [String, Pathname] path The path to your YAML file(s)
      #
      # @return [Gateway]
      #
      # @api public
      def self.new(path)
        sources, mode = load_from(path)
        super(sources, mode: mode)
      end

      # Load data from yaml file(s)
      #
      # @api private
      def self.load_from(path)
        if File.directory?(path)
          [load_files(path), :one]
        else
          sources = load_file(path).each_with_object({}) do |(ns, data), h|
            h[ns] = { data: data, path: path }
          end
          [sources, sources.keys.size == 1 ? :one : :many]
        end
      end

      # Load yaml files from a given directory and return a name => data map
      #
      # @api private
      def self.load_files(path)
        Dir["#{path}/*.yml"]
          .reject{ |f| f.match('testing') }
          .each_with_object({}) do |file, h|

          name = source_name(file)
          h[name] = {
            data: load_file(file).fetch(name),
            path: file
          }
        end
      end

      def self.source_name(filename)
        File.basename(filename, '.*')
      end

      # Load yaml file
      #
      # @api private
      def self.load_file(path)
        ::YAML.load_file(path)
      end

      # @param [Hash] sources The hashmap containing data loaded from files
      #
      # @api private
      def initialize(sources, options = {})
        @sources = sources
        @datasets = {}
        @mode = options[:mode]
      end

      # Return dataset by its name
      #
      # @param [Symbol]
      #
      # @return [Array<Hash>]
      #
      # @api public
      def [](name)
        datasets.fetch(name)
      end

      # Register a new dataset
      #
      # @param [Symbol]
      #
      # @return [Dataset]
      #
      # @api public
      def dataset(name)
        dataset_source = sources.fetch(name.to_s)
        datasets[name] = Dataset.new(
          dataset_source.fetch(:data),
          dataset_name: name.to_sym,
          path: dataset_source.fetch(:path),
          mode: mode
        )
      end

      # Return if a dataset with provided name exists
      #
      # @api public
      def dataset?(name)
        datasets.key?(name)
      end

      private

      attr_reader :mode
    end
  end
end
