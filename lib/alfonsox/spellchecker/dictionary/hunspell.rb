# frozen_string_literal: true

require 'Hunspell'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    module Dictionary
      # Hunspell dictionary loader
      class Hunspell
        attr_reader :language, :path
        def initialize(language, path = nil)
          @language = language
          @path = path
          find_dictionary_path unless @path
          initialize_spellchecker
        end

        def self.from_config(yml_config)
          new(yml_config['language'], yml_config['path'])
        end

        def word_present?(word)
          @spellchecker.spellcheck(word)
        end

        def similar_words(word)
          @spellchecker.suggest(word)
        end

        private

        # Try to find the dictionary path of the selected language
        # @raise [Exception] Raise an exception if no dictionary is found for the selected language.
        # @return [String] dictionary path for language.
        def find_dictionary_path
          dictionary_paths.each do |path|
            if dictionary_exists?(path)
              @path = path
              return @path
            end
          end
          raise "'#{@language}' language Hunspell dictionary not found installed in your system"
        end

        # Return an array of the hunspell dictionary paths
        def dictionary_paths
          output = `hunspell -D 2>&1`
          hunspell_output_lines = output.split("\n")
          i = 0
          while i < hunspell_output_lines.length
            break if hunspell_output_lines[i].start_with?('AVAILABLE DICTIONARIES')
            i += 1
          end
          i += 1
          dict_file_paths = Set.new(hunspell_output_lines[i..(hunspell_output_lines.length - 1)])
          dict_file_paths.map { |path| path.split('/')[0..-2].join('/') }
        end

        # Check if a hunspell dictionary exists for the selected language
        def dictionary_exists?(path)
          aff_file_exists = ::File.exist?("#{path}/#{@language}.aff")
          dic_file_exists = ::File.exist?("#{path}/#{@language}.dic")
          aff_file_exists && dic_file_exists
        end

        def initialize_spellchecker
          @spellchecker = spellchecker_from_local_file_prefix ||
                          spellchecker_from_directory
        end

        def spellchecker_from_local_file_prefix
          aff_file_exists = ::File.exist?("#{@path}.aff")
          dic_file_exists = ::File.exist?("#{@path}.dic")
          return false unless aff_file_exists && dic_file_exists
          ::Hunspell.new("#{@path}.aff", "#{@path}.dic")
        end

        def spellchecker_from_directory
          ::Hunspell.new("#{@path}/#{@language}.aff", "#{@path}/#{@language}.dic")
        end
      end
    end
  end
end
