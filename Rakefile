require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run rspec'
RSpec::Core::RakeTask.new(:spec)

desc 'Default task :test'
task :default => :test

desc 'Run tests'
task :test => :spec
