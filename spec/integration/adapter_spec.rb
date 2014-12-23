require 'spec_helper'

describe 'YAML adapter' do
  subject(:rom) { setup.finalize }

  let(:root) { Pathname(__FILE__).dirname.join('..') }

  let(:setup) { ROM.setup("yaml://#{root}/fixtures/test_db.yml") }

  before do
    setup.schema do
      base_relation(:users) do
        repository :default

        attribute 'name'
        attribute 'email'
        attribute 'roles'
      end
    end

    setup.relation(:users) do
      def by_name(name)
        find_all { |user| user['name'] == name }
      end
    end

    setup.mappers do
      define(:users) do
        model name: 'User'

        attribute :name, from: 'name'
        attribute :email, from: 'email'

        embedded :roles, from: 'roles' do
          attribute :name, from: 'role_name'
        end
      end
    end
  end

  describe 'env#read' do
    it 'returns mapped object' do
      jane = rom.read(:users).by_name('Jane').to_a.first

      expect(jane.name).to eql('Jane')
      expect(jane.email).to eql('jane@doe.org')
      expect(jane.roles.length).to eql(2)
      expect(jane.roles).to eql([
        { name: 'Member' } , { name: 'Admin' }
      ])
    end
  end
end
