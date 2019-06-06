# frozen_string_literal: true

# inside tasks/test.rake
require 'rake/testtask'

desc 'Run tests'
Rake::TestTask.new(:test) do |t|
  t.libs.push 'test'
  t.test_files = FileList['test/enable_coverage.rb', 'test/**/*_test.rb']
  t.warning = ENV['warning']
  t.verbose = ENV['verbose']
end

desc 'Generates a coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

task default: :test
