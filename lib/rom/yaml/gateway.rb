require 'yaml'

require 'rom/gateway'
require 'rom/yaml/dataset'

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
        super(load_from(path))
      end

      # Load data from yaml file(s)
      #
      # @api private
      def self.load_from(path)
        if File.directory?(path)
          load_files(path)
        else
          load_file(path)
        end
      end

      # Load yaml files from a given directory and return a name => data map
      #
      # @api private
      def self.load_files(path)
        Dir["#{path}/*.yml"].each_with_object({}) do |file, h|
          name = File.basename(file, '.*')
          h[name] = load_file(file).fetch(name)
        end
      end

      # Load yaml file
      #
      # @api private
      def self.load_file(path)
        ::YAML.load_file(path)
      end

      # @param [String] path The absolute path to yaml file
      #
      # @api private
      def initialize(sources)
        @sources = sources
        @datasets = {}
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
        datasets[name] = Dataset.new(sources.fetch(name.to_s))
      end

      # Return if a dataset with provided name exists
      #
      # @api public
      def dataset?(name)
        datasets.key?(name)
      end
    end
  end
end
