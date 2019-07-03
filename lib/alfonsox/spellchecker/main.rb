# frozen_string_literal: true

require 'alfonsox/spellchecker/file'
require 'yaml'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    # Main spellchecker class
    class Main
      attr_reader :paths, :dictionaries

      # Construct a spellchecker object from the paths it must check and a dictionary
      def initialize(paths, dictionaries)
        @paths = if paths.is_a?(String)
                   [paths]
                 else
                   paths
                 end
        @dictionaries = if dictionaries.is_a?(Array)
                          dictionaries
                        else
                          [dictionaries]
                        end
        @dictionaries = @dictionaries.concat([AlfonsoX::SpellChecker::Dictionary::Default.new])
      end

      # Load from config
      # @param [String] config_file_path Config file path that will be loaded.
      # @return [AlfonsoX::SpellChecker::Dictionary::Hunspell, AlfonsoX::SpellChecker::Dictionary::Rubymine]
      #         Dictionary ready to be used by #AlfonsoX::SpellChecker::Main class.
      def self.from_config(config_file_path)
        config_file = YAML.load_file(config_file_path)
        dictionary_class_from_type = lambda do |config_dictionary_type|
          return AlfonsoX::SpellChecker::Dictionary::Hunspell if config_dictionary_type == 'hunspell'
          return AlfonsoX::SpellChecker::Dictionary::Rubymine if config_dictionary_type == 'rubymine'
          return AlfonsoX::SpellChecker::Dictionary::WordList if config_dictionary_type == 'word_list'
          return AlfonsoX::SpellChecker::Dictionary::WordListFile if config_dictionary_type == 'word_list_file'
          raise "Dictionary type #{config_dictionary_type} is not recognized"
        end

        dictionaries = config_file['Dictionaries'].map do |dictionary_config|
          _dictionary_local_name = dictionary_config[0]
          actual_dictionary_config = dictionary_config[1]
          dictionary_class = dictionary_class_from_type.call(actual_dictionary_config['type'])
          dictionary_class.from_config(actual_dictionary_config)
        end

        AlfonsoX::SpellChecker::Main.new(config_file['Paths'], dictionaries)
      end

      # Spellcheck all the paths.
      # @return [Array<AlfonsoX::SpellChecker::Word>] array of the incorrect words by file.
      def check_all
        incorrect_words_by_file = {}
        @paths.each do |path|
          rb_file_paths = Dir.glob(path).map { |expanded_path| ::File.realpath(expanded_path) }
          rb_file_paths.each do |rb_file|
            file_incorrect_words = check_file(rb_file)
            next unless file_incorrect_words.length.positive?
            incorrect_words_by_file[rb_file] = file_incorrect_words
          end
        end
        incorrect_words_by_file
      end

      # Spellcheck some files.
      # @param [Array<String>] applicable_files List of full file paths that will be spell-checked. Optional.
      # @return [Array<AlfonsoX::SpellChecker::Word>] array of the incorrect words by file.
      def check(applicable_files = nil)
        return check_all unless applicable_files
        incorrect_words_by_file = {}
        applicable_files.each do |applicable_file_i|
          file_incorrect_words = check_file(applicable_file_i)
          next unless file_incorrect_words.length.positive?
          incorrect_words_by_file[applicable_file_i] = file_incorrect_words
        end
        incorrect_words_by_file
      end

      private

      # Spellcheck a file given its file_path.
      # @return [Array<AlfonsoX::SpellChecker::Word>] array of the incorrect words for the file.
      def check_file(file_path)
        spell_checked_file = AlfonsoX::SpellChecker::File.new(file_path, @dictionaries)
        spell_checked_file.spellcheck
        spell_checked_file.incorrect_words
      end
    end
  end
end
