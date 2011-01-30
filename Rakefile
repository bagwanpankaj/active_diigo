require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "active_diigo"
  gem.homepage = "http://github.com/bagwanpankaj/active_diigo"
  gem.license = "MIT"
  gem.summary = %Q{Diigo Restful API wrapper; much like ActiveRecord}
  gem.description = %Q{ActiveDiigo is a wrapper for Diigo API(version: v2).}
  gem.email = "me@bagwanpankaj.com"
  gem.authors = ["Bagwan Pankaj"]
  gem.files = [
    "lib/active_diigo/errors.rb",
    "lib/active_diigo/request.rb",
    "lib/active_diigo/response_object.rb",
    "lib/active_diigo/base.rb",
    "lib/active_diigo.rb",
    "LICENSE.txt",
    "VERSION"
  ]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
