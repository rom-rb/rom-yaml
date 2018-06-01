require 'spec_helper'

require 'rom/lint/spec'

RSpec.describe ROM::YAML::Dataset do
  let(:data) { [{ id: 1 }, { id: 2 }] }
  let(:dataset) do
    ROM::YAML::Dataset.new(
      data, path: "foo.yml", mode: :one, dataset_name: :foo
    )
  end

  it_behaves_like "a rom enumerable dataset"

  it "symbolizes keys" do
    dataset = ROM::YAML::Dataset.new(
      ["foo" => 23], path: "foo.yml", mode: :one, dataset_name: :foo
    )
    expect(dataset.to_a).to eq([{ foo: 23 }])
  end

  it "symbolizes keys recursively" do
    sources = ["foo" => { "bar" => :baz }]
    dataset = ROM::YAML::Dataset.new(
      sources, path: "foo.yml", mode: :one, dataset_name: :foo
    )
    expect(dataset.to_a).to eq([foo: { bar: :baz }])
  end
end
