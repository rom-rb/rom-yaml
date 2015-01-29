require 'rom/repository'
require 'rom/yaml/dataset'

module ROM
  module YAML
    Relation = Class.new(ROM::Relation)

    class Repository < ROM::Repository
      attr_reader :datasets

      def initialize(path)
        @datasets = {}
        @connection = ::YAML.load_file(path)
      end

      def [](name)
        datasets.fetch(name)
      end

      def dataset(name)
        datasets[name] = Dataset.new(connection.fetch(name.to_s))
      end

      def dataset?(name)
        datasets.key?(name)
      end
    end
  end
end
