require "bundler/gem_tasks"
require 'yard'

desc "Test the things"
require 'vault-test-tools/rake_task'

desc "Doc the things"
YARD::Rake::YardocTask.new

desc "Create test databases and run the test suite"
task :default => [:test]

desc "Run all pull schema tasks (all tasks that match pull_.*_schema)"
task :pull_schemas do
  Rake::Task.tasks.select { |task| task.name =~ /pull_.*_schema/ }.each do |task|
    puts "Invoking #{task.name}..."
    task.invoke
  end
end
