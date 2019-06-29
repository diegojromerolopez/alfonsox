# frozen_string_literal: true

require 'alfonsox'

# Alfonso X module
module AlfonsoX
  # Command Line Interpreter tool for Alfonso X
  class CLI
    # Take the config file path
    def initialize
      @config_file_path = config_file_path
    end

    # Run spell-check on files specified by config file
    def run
      spellchecker = AlfonsoX::SpellChecker::Main.from_config(@config_file_path)
      spellchecker_errors_by_file = spellchecker.check
      exit_status = 0
      spellchecker_errors_by_file.each do |file_path, spellchecker_errors|
        spellchecker_errors.each do |spellchecker_error_i|
          puts "#{file_path}:#{spellchecker_error_i.line} #{spellchecker_error_i.word}"
          exit_status = 1
        end
      end
      exit exit_status
    end

    private

    # Return the config file path
    # @return [String] config file path that will be used when running Alfonso X tool.
    def config_file_path
      repo_config_file_path_yml = File.join(AlfonsoX::Utils.repo_root, AlfonsoX::CONFIG_FILE_NAME)
      return repo_config_file_path_yml if File.exist?(repo_config_file_path_yml)
      File.join(AlfonsoX::CONFIG_PATH, 'default.yml')
    end
  end
end
