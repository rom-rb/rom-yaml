require 'spec_helper'

RSpec.describe 'Commands / Delete' do
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

      def by_name(name)
        restrict(name: name)
      end
    end
  end

  before do
    FileUtils.copy(original_path, path)

    configuration.register_relation(testing_relation)
  end

  it 'deletes all tuples in a restricted relation' do
    command = relation.command(:delete, result: :one).by_name("Jane")
    result = command.call

    expect(result)
      .to eql(name: "Jane", email: "jane@doe.org")

    expect(relation.to_a.size).to eql(0)
  end
end
