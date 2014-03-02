require 'rubygems'
require 'rake/testtask'
require 'cucumber'
require 'cucumber/rake/task'
require "bundler/gem_tasks"

Rake::TestTask.new(:unit) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*\.rb'
end

Cucumber::Rake::Task.new(:features) do |t|
  if RUBY_VERSION == '1.9.2'
    t.profile = '1.9.2'
  else
    t.profile = 'default'
  end
end

desc 'Run all unit tests and features'
task :test => [:unit, :features]

task :default => :test
