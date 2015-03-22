require 'yaml'

require 'rom/repository'
require 'rom/yaml/dataset'

module ROM
  module YAML
    # YAML repository
    #
    # @example
    #   repository = ROM::YAML::Repository.new('/path/to/data.yml')
    #   repository.dataset(:users)
    #   repository.dataset?(:users) # => true
    #   repository[:users]
    #
    # Connects to a yaml file and use it as a data-source
    #
    # @api public
    class Repository < ROM::Repository
      # Registered datasets
      #
      # @api private
      attr_reader :datasets

      # @param [String] path The absolute path to yaml file
      #
      # @api private
      def initialize(path)
        @datasets = {}
        @connection = ::YAML.load_file(path)
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
        datasets[name] = Dataset.new(connection.fetch(name.to_s))
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
