require 'spec_helper'

RSpec.describe 'Commands / Create' do
  let(:configuration) do
    ROM::Configuration.new(:yaml, path)
  end

  let(:root) { Pathname(__FILE__).dirname.join('../..') }
  let(:container) { ROM.container(configuration) }
  let(:relations) { container[:relations] }

  subject(:relation) { relations[:users] }

  let(:original_path) { "#{root}/fixtures/db/users.yml" }
  let(:path) { "#{root}/fixtures/db/testing.yml" }

  let(:testing_relation) do
    Class.new(ROM::YAML::Relation) do
      schema(:users) do
        attribute :name, ROM::Types::String
        attribute :email, ROM::Types::String
      end
    end
  end

  before do
    FileUtils.copy(original_path, path)

    configuration.register_relation(testing_relation)
  end

  it 'returns a single tuple when result is set to :one' do
    command = relation.command(:create, result: :one)
    result = command.call(name: 'John', email: 'john@doe.org')
    expect(result)
      .to eql(name: 'John', email: 'john@doe.org')

    expect(relation.to_a.size).to eql(2)
  end

  it 'returns tuples when result is set to :many' do
    command = relation.command(:create, result: :many)
    result = command
             .call([
                     { name: 'Jane', email: 'jane@doe.org' },
                     { name: 'Jack', email: 'jack@doe.org' }
                   ])

    expect(result)
      .to match_array([
                        { name: 'Jane', email: 'jane@doe.org' },
                        { name: 'Jack', email: 'jack@doe.org' }
                      ])

    expect(relation.to_a.size).to eql(3)
  end
end
