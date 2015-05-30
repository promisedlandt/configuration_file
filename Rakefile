require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

task :guard do
  sh "guard --no-interactions --notify false --clear"
end

task :rubocop do
  sh "rubocop --format simple"
end

YARD::Rake::YardocTask.new do |t|
  t.options = ["--no-private"]
end

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/*_test.rb"
  test.verbose = true
end

desc "for travis-ci run"
task travis: :default

task default: [:test, :rubocop]
