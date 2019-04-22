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

        auto_struct true

        def by_name(name)
          restrict(name: name)
        end
      end
    end

    before do
      configuration.register_relation(users_relation)
    end

    describe 'Relation#first' do
      it 'returns mapped struct' do
        jane = rom.relations[:users].by_name('Jane').first

        expect(jane.name).to eql('Jane')
        expect(jane.email).to eql('jane@doe.org')
        expect(jane.roles.length).to eql(2)
        expect(jane.roles).to eql([
          { role_name: 'Member' }, { role_name: 'Admin' }
        ])
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

    it 'uses one-file-per-relation' do
      expect(rom.relations[:users].to_a).to eql([
        { name: 'Jane', email: 'jane@doe.org' }
      ])

      expect(rom.relations[:tasks].to_a).to eql([
        { title: 'Task One' },
        { title: 'Task Two' },
        { title: 'Task Three' }
      ])
    end
  end
end
