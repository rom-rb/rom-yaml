module ROM
  module YAML
    class Adapter < ROM::Adapter
      def self.schemes
        [:yaml]
      end

      def initialize(*args)
        super
        @connection = ::YAML.load_file("#{uri.host}#{uri.path}")
      end

      def [](name)
        connection.fetch(name.to_s)
      end

      def dataset?(name)
        connection.key?(name.to_s)
      end
    end
  end
end
