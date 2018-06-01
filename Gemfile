source 'https://rubygems.org'

gemspec

group :test do
  gem 'rom', git: 'https://github.com/rom-rb/rom.git', branch: 'master' do
    gem 'rom-changeset'
    gem 'rom-core'
    gem 'rom-mapper'
    gem 'rom-repository'
  end

  gem 'byebug', platform: :mri
  gem 'codeclimate-test-reporter', require: false
  gem 'inflecto'
  gem 'rspec', '~> 3.1'
  gem 'virtus'
end

group :tools do
  gem 'rubocop'
end
