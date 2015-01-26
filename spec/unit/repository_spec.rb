require 'spec_helper'

require 'rom/lint/spec'

describe ROM::YAML::Repository do
  let(:root) { Pathname(__FILE__).dirname.join('..') }

  it_behaves_like 'a rom repository' do
    let(:identifier) { :yaml }
    let(:repository) { ROM::YAML::Repository }
    let(:uri) { "#{root}/fixtures/test_db.yml" }
  end
end
