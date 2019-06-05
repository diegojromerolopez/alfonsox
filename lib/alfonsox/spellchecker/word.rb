# frozen_string_literal: true

# Alfonso X module
module AlfonsoX
  module SpellChecker
    # Each of the spell-checked words
    class Word
      attr_reader :word, :line

      def initialize(word, line, dictionaries)
        @word = word
        @line = line
        @dictionaries = dictionaries
        @right = nil
      end

      def check
        @dictionaries.each do |dictionary|
          @right = check_for_dictionary(dictionary)
          return true if @right
        end
        false
      end

      private

      def check_for_dictionary(dictionary)
        right = dictionary.word_present?(@word)
        return true if right
        false
      end
    end
  end
end
