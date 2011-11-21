#!/usr/bin/env rake

require "rubygems"
require "rubygems/package_task"

require "rake/testtask"
require "rdoc/task"

task :default => :test

spec = Gem::Specification.load("going_postal.gemspec")
Gem::PackageTask.new(spec) {}

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

Rake::RDocTask.new do |t|
  t.main = "README.rdoc"
  t.rdoc_dir = "doc"
  t.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end
