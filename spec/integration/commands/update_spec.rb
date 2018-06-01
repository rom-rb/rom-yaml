require 'spec_helper'

RSpec.describe 'Commands / Updates' do
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
        attribute :user_id, ROM::Types::String
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

  it 'updates everything when there is no original tuple' do
    command = relation.command(:update)
    result = command.by_name("Jane").call(email: 'tester@example.com')

    expect(result)
      .to eql(name: 'Jane', email: 'tester@example.com')

    result = relation.by_name("Jane").to_a.first
    expect(result[:email]).to eql('tester@example.com')
  end
end
