# frozen_string_literal: true

require 'alfonsox/spellchecker/word'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    # Each one of the source code files we want to spell-check
    class File
      attr_reader :incorrect_words
      def initialize(file_path, dictionary)
        @file_path = file_path
        @dictionary = dictionary
        @incorrect_words = []
      end

      def spellcheck
        lines = ::File.open(@file_path).readlines
        lines.each_with_index do |line, line_index|
          check_line(line, line_index + 1)
        end
        @incorrect_words
      end

      def incorrect_words?
        @incorrect_words.length.positive?
      end

      # Split words of a line.
      # @param [String] word_line A line of a text.
      # @return [Array<String>] Words of the word_line.
      def self.word_splitter(word_line)
        word_line.split(/[_\-\s]+|(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])/)
      end

      private

      def check_line(line, line_number)
        line_words = self.class.word_splitter(line)
        line_words.each do |word|
          spell_checked_word = AlfonsoX::SpellChecker::Word.new(word, line_number, @dictionary)
          word_is_right = spell_checked_word.check
          next if word_is_right
          @incorrect_words << spell_checked_word
        end
      end
    end
  end
end
