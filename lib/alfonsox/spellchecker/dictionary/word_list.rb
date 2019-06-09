# frozen_string_literal: true

require 'nokogiri'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    module Dictionary
      # Custom dictionary loader composed by a word list
      class WordList
        # Initialize a AlfonsoX::SpellChecker::Dictionary::WordList
        # @param [Array<String>] word_list Words that are included in this dictionary
        def initialize(word_list)
          @words = word_list.map(&:downcase)
        end

        def self.from_config(yml_config)
          new(yml_config.fetch('word_list') { [] })
        end

        def word_present?(word)
          @words.include?(word.downcase)
        end
      end
    end
  end
end
