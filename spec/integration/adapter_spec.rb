require 'spec_helper'

require 'rom/lint/spec'
require 'rom/repository'

RSpec.describe ROM::YAML do
  let(:configuration) do
    ROM::Configuration.new(:yaml, path)
  end

  let(:root) { Pathname(__FILE__).dirname.join('..') }
  let(:container) { ROM.container(configuration) }

  subject(:rom) { container }

  describe "single file configuration" do
    let(:path) { "#{root}/fixtures/test_db.yml" }

    let(:users_relation) do
      Class.new(ROM::YAML::Relation) do
        schema(:users) do
          attribute :name, ROM::Types::String
          attribute :email, ROM::Types::String
          attribute :roles, ROM::Types::Array
        end

        def by_name(name)
          restrict(name: name)
        end
      end
    end

    let(:user_mapper) do
      Class.new(ROM::Mapper) do
        relation :users
        register_as :entity

        model name: 'Test::User'

        attribute :name
        attribute :email

        embedded :roles, type: :array do
          attribute :name, from: 'role_name'
        end
      end
    end

    before do
      configuration.register_relation(users_relation)
      configuration.register_mapper(user_mapper)
    end

    describe 'env#relation' do
      it 'returns mapped object' do
        jane = rom.relations[:users].map_with(:entity).by_name('Jane').first

        expect(jane.name).to eql('Jane')
        expect(jane.email).to eql('jane@doe.org')
        expect(jane.roles.length).to eql(2)
        expect(jane.roles).to eql([
                                    { name: 'Member' }, { name: 'Admin' }
                                  ])
      end
    end

    describe 'with a repository' do
      let(:repo) do
        Class.new(ROM::Repository[:users]).new(rom)
      end

      it 'auto-maps to structs' do
        user = repo.users.first

        expect(user.name).to eql('Jane')
        expect(user.email).to eql('jane@doe.org')
        expect(user.roles.size).to be(2)
      end
    end
  end

  describe 'multi-file setup' do
    let(:path) { "#{root}/fixtures/db" }

    let(:users_relation) do
      Class.new(ROM::YAML::Relation) do
        schema :users do
          attribute :name, ROM::Types::String
          attribute :email, ROM::Types::String
        end
      end
    end

    let(:tasks_relation) do
      Class.new(ROM::YAML::Relation) do
        schema :tasks do
          attribute :title, ROM::Types::String
        end
      end
    end

    before do
      configuration.register_relation(users_relation)
      configuration.register_relation(tasks_relation)
    end

    let(:user_results) do
      [
        { name: 'Jane', email: 'jane@doe.org' }
      ]
    end

    let(:task_results) do
      [
        { title: 'Task One' },
        { title: 'Task Two' },
        { title: 'Task Three' }
      ]
    end

    it 'uses one-file-per-relation' do
      expect(rom.relations[:users].to_a).to eql(user_results)

      expect(rom.relations[:tasks].to_a).to eql(task_results)
    end
  end
end
