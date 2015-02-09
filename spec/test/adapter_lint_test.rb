require 'rom-yaml'
require 'rom/adapter/lint/test'

require 'minitest/autorun'

class MemoryAdapterLintTest < MiniTest::Test
  include ROM::Adapter::Lint::TestAdapter

  def setup
    @adapter = ROM::YAML::Adapter
    @uri = "yaml://#{File.expand_path('./spec/fixtures/test_db.yml')}"
  end
end

class MemoryAdapterDatasetLintTest < MiniTest::Test
  include ROM::Adapter::Lint::TestEnumerableDataset

  def setup
    @data  = [{ name: 'Jane', age: 24 }, { name: 'Joe', age: 25 }]
    @dataset = ROM::YAML::Dataset.new(@data, [:name, :age])
  end
end
