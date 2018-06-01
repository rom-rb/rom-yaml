require 'rom/commands'
require 'rom/commands/update'

module ROM
  module YAML
    module Commands
      class Update < ROM::Memory::Commands::Update
        def execute(params)
          attributes = input[params].to_h
          relation.map { |tuple| update(tuple, attributes) }.tap do
            dataset.sync!
          end
        end

        private

        def update(tuple, attributes)
          index = data.index(tuple)
          data[index].update(attributes)
        end

        def dataset
          source.dataset
        end

        def data
          dataset.data
        end
      end
    end
  end
end
