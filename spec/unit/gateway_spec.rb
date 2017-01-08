require 'spec_helper'

require 'rom/lint/spec'

RSpec.describe ROM::YAML::Gateway do
  let(:root) { Pathname(__FILE__).dirname.join('..') }

  it_behaves_like 'a rom gateway' do
    let(:identifier) { :yaml }
    let(:gateway) { ROM::YAML::Gateway }
    let(:uri) { "#{root}/fixtures/test_db.yml" }
  end
end
