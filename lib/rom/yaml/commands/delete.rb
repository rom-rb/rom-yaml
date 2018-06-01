module ROM
  module YAML
    module Commands
      class Delete < ROM::Memory::Commands::Delete
        def execute
          super.tap { source.dataset.sync! }
        end
      end
    end
  end
end
