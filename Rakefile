# frozen_string_literal: true

# inside tasks/test.rake
require 'rake/testtask'
require 'alfonsox'

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

desc 'Spell checks a project'
task :spellcheck, [:config_path] => [] do |_t, args|
  args.with_defaults(config_path: 'alfonsox.yml')
  puts "Starting spellcheck using configuration #{args.config_path}"
  spellchecker = AlfonsoX::SpellChecker::Main.from_config(args.config_path)
  spellchecker.check
end

task default: :test
