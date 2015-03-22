require 'yaml'

require 'rom/repository'
require 'rom/yaml/dataset'

module ROM
  module YAML
    # YAML repository
    #
    # Connects to a yaml file and uses it as a data-source
    #
    # @example
    #   ROM.setup(:yaml, '/path/to/data.yml')
    #
    #   rom = ROM.finalize.env
    #
    #   repository = rom.repositories[:default]
    #
    #   repository.dataset?(:users) # => true
    #   repository[:users] # => data under 'users' key from the yaml file
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

        if File.directory?(path)
          @connection = Dir["#{path}/*.yml"].each_with_object({}) do |file, h|
            name = File.basename(file, '.*')
            data = ::YAML.load_file(file)[name]
            h[name] = data
          end
        else
          @connection = ::YAML.load_file(path)
        end
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
