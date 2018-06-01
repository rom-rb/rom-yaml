module ROM
  module YAML
    module Commands
      class Create < ROM::Memory::Commands::Create
        def execute(tuples)
          super(tuples).tap { relation.dataset.sync! }
        end
      end
    end
  end
end
