#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new("test:integration") do |t|
  t.libs << "test" << "lib"
  t.pattern = "test/integration/**/*_test.rb"
end

task :fixtures do
  ruby "-I test script/fake_gems.rb"
end

task :test => ["test:integration"]
task :default => :test

