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
  t.profile = 'default'
end

desc 'Run all unit tests and features'
task :test => [:unit, :features]

task :default => :test
