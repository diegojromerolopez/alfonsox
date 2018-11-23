# frozen_string_literal: true

# Alfonso X module
module AlfonsoX
  module SpellChecker
    # Each of the spell-checked words
    class Word
      attr_reader :word

      def initialize(word, line, dictionary)
        @word = word
        @line = line
        @dictionary = dictionary
        @right = nil
        @suggestions = nil
      end

      def check
        right = @dictionary.word_present?(@word)
        if right
          @right = true
        else
          @right = false
          @suggestions = @dictionary.similar_words(@word)
        end
        @right
      end

      def right?
        @right
      end
    end
  end
end
