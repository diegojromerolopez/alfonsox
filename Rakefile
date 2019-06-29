# frozen_string_literal: true

# inside tasks/test.rake
require 'rake/testtask'
require 'alfonsox'

# Include this Rakefile in your project's Rakefile by typing:
# alfonsox_gem = Gem::Specification.find_by_name('alfonsox')
# load("#{alfonsox_gem.gem_dir}/Rakefile")

namespace :alfonsox do
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
  task :spellcheck do
    AlfonsoX::CLI.new.run
  end
end

