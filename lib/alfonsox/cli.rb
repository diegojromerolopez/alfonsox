# frozen_string_literal: true

require 'alfonsox'

# Alfonso X module
module AlfonsoX
  # Command Line Interpreter tool for Alfonso X
  class CLI
    # Success exit status code
    SUCCESS_EXIT_STATUS = 0

    # Error exit status code
    ERROR_EXIT_STATUS = 1

    # Take the config file path
    def initialize
      @config_file_path = config_file_path
    end

    # Run spell-check on files specified by config file
    def run
      spellchecker = AlfonsoX::SpellChecker::Main.from_config(@config_file_path)
      spellchecker_errors_by_file = spellchecker.check
      exit_status = SUCCESS_EXIT_STATUS
      spellchecker_errors_by_file.each do |file_path, spellchecker_errors|
        spellchecker_errors.each do |spellchecker_error_i|
          print_spellcheck_error(file_path, spellchecker_error_i)
          exit_status = ERROR_EXIT_STATUS
        end
      end

      print_status(exit_status)
      exit(exit_status)
    end

    private

    # Return the config file path
    # @return [String] config file path that will be used when running Alfonso X tool.
    def config_file_path
      repo_config_file_path_yml = File.join(AlfonsoX::Utils.repo_root, AlfonsoX::CONFIG_FILE_NAME)
      return repo_config_file_path_yml if File.exist?(repo_config_file_path_yml)
      File.join(AlfonsoX::CONFIG_PATH, 'default.yml')
    end

    # Shows a lone spellcheck error in the standard error output
    def print_spellcheck_error(file_path, spellchecker_error)
      STDERR.puts "#{file_path}:#{spellchecker_error.line} #{spellchecker_error.word}"
    end

    # Print status of the spellcheck
    def print_status(exit_status)
      if exit_status == SUCCESS_EXIT_STATUS
        print_success_status
      elsif exit_status == ERROR_EXIT_STATUS
        print_error_status
      end
    end

    # Informs that everything went well
    def print_success_status
      STDOUT.puts '✔ Code is spell-checked correctly'
    end

    # Informs that something went wrong
    def print_error_status
      STDERR.puts '✗ Errors in in code spellchecking'
    end
  end
end
