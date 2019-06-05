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
      end

      # Load from config
      def self.from_config(config_file_path)
        config_file = YAML.load_file(config_file_path)
        dictionary_class_from_type = lambda do |config_dictionary_type|
          return AlfonsoX::SpellChecker::Dictionary::Hunspell if config_dictionary_type == 'hunspell'
          return AlfonsoX::SpellChecker::Dictionary::Rubymine if config_dictionary_type == 'rubymine'
          p config_dictionary_type
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
      def check
        incorrect_words_by_file = {}
        @paths.each do |path|
          Dir.glob(path) do |rb_file|
            file_incorrect_words = check_file(rb_file)
            next unless file_incorrect_words.length.positive?
            incorrect_words_by_file[rb_file] = file_incorrect_words
          end
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
