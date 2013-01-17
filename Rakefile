require 'rubygems'
require 'rake/testtask'
require 'cucumber'
require 'cucumber/rake/task'
require "bundler/gem_tasks"

task :default => :test
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*\.rb'
end

Cucumber::Rake::Task.new(:features) do |t|
  t.profile = 'default'
end
