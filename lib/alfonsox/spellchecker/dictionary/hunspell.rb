# frozen_string_literal: true

require 'Hunspell'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    module Dictionary
      # Hunspell dictionary loader
      class Hunspell
        # Default hunspell dictionary path
        DEFAULT_PATH = "#{AlfonsoX::DICTIONARIES_PATH}/hunspell"
        # All attributes are readable
        attr_reader :language, :path

        # Construct a hunspell dictionary object for this package
        def initialize(language, path = nil)
          @language = language
          @path = path || DEFAULT_PATH
          initialize_spellchecker(path)
        end

        # Load a hunspell dictionary from configuration
        def self.from_config(yml_config)
          new(yml_config['language'], yml_config.fetch('path') { DEFAULT_PATH })
        end

        # Inform if a word is present in this dictionary.
        def word_present?(word)
          @spellchecker.spellcheck(word)
        end

        # Initialize spellchecker attribute
        def initialize_spellchecker(path)
          dictionary_finder = DictionaryFinder.new(@language, path)
          raise "'#{@language}' language Hunspell dictionary not found" unless dictionary_finder.find
          @spellchecker = ::Hunspell.new(dictionary_finder.aff_file_path, dictionary_finder.dic_file_path)
        end
      end

      # Finds the dictionary in this Gem
      class DictionaryFinder
        attr_reader :aff_file_path, :dic_file_path
        PATH = "#{AlfonsoX::DICTIONARIES_PATH}/hunspell"

        def initialize(language, path = nil)
          @language = language
          @path = path
          @aff_file_path = nil
          @dic_file_path = nil
        end

        def find
          paths = [@path, "#{AlfonsoX::DICTIONARIES_PATH}/hunspell"].compact
          paths.each do |path|
            @aff_file_path, @dic_file_path = DictionaryFinder.find_from_language(@language, path)
            return true if @aff_file_path && @dic_file_path
          end
          false
        end

        # Find language dictionary in a path
        # @return [Array<String, nil>] an array with two elements.
        #         If they are both strings, it will be the paths of aff and dic files.
        #         Otherwise, if they are both nils, no dictionary could be found for the language.
        def self.find_from_language(language, path)
          standard_language = language.split('_')[0]
          languages = [language, standard_language, "#{standard_language}_ANY}"]
          languages.each do |language_directory|
            next unless ::Dir.exist?("#{path}/#{language_directory}")
            languages.each do |language_file|
              file_common_path = "#{path}/#{language_directory}/#{language_file}"
              aff_file_path = "#{file_common_path}.aff"
              dic_file_path = "#{file_common_path}.dic"
              aff_file_exists = ::File.exist?(aff_file_path)
              dic_file_exists = ::File.exist?(dic_file_path)
              return aff_file_path, dic_file_path if aff_file_exists && dic_file_exists
            end
          end
          [nil, nil]
        end
      end
    end
  end
end
