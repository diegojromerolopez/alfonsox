# frozen_string_literal: true

require 'nokogiri'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    module Dictionary
      # Custom dictionary loader composed by a word list from a file
      class WordListFile
        attr_reader :words

        # Initialize a AlfonsoX::SpellChecker::Dictionary::WordListFile from a file path.
        # Note the words must be in different lines.
        # @param [String] word_list_file_path Word list file path.
        def initialize(word_list_file_path)
          word_list = ::File.readlines(word_list_file_path).map(&:chomp)
          @words = word_list.map(&:downcase)
        end

        # Load from Yml
        def self.from_config(yml_config)
          new(yml_config['path'])
        end

        # Inform if a word is present in this dictionary.
        def word_present?(word)
          @words.include?(word.downcase)
        end
      end
    end
  end
end
