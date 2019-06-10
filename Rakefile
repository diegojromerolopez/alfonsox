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

namespace :alfonsox do
  desc 'Spell checks a project'
  task :spellcheck, [:config_path] => [] do |_t, args|
    if args.config_path
      puts "Starting spellcheck using configuration #{args.config_path}"
    else
      puts 'No custom configuration, starting spellcheck using default configuration'
    end
    config_path = args.config_path || ALFONSOX_DEFAULT_CONFIGURATION_PATH
    spellchecker = AlfonsoX::SpellChecker::Main.from_config(config_path)
    spellchecker_errors_by_file = spellchecker.check
    spellchecker_errors_by_file.each do |file_path, spellchecker_errors|
      spellchecker_errors.each do |spellchecker_error_i|
        puts "#{file_path}:#{spellchecker_error_i.line} #{spellchecker_error_i.word}"
      end
    end
  end
end

task default: :test
