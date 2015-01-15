require 'rom/repository'
require 'rom/yaml/dataset'

module ROM
  module YAML
    class Repository < ROM::Repository
      attr_reader :datasets

      def self.schemes
        [:yaml]
      end

      def setup
        @datasets = {}
        @connection = ::YAML.load_file("#{uri.host}#{uri.path}")
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
