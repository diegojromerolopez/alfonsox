# frozen_string_literal: true

require 'alfonsox/spellchecker/word'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    # Each one of the source code files we want to spell-check
    class File
      attr_reader :incorrect_words

      # Initialize spellcheck on a file with some dictionaries
      # @param [String] file_path File path of the file to be spellchecked.
      # @param [Array<AlfonsoX::SpellChecker::Dictionary::Hunspell, AlfonsoX::SpellChecker::Dictionary::Rubymine>]
      #        dictionaries Array of dictionaries, as constructed by AlfonsoX package.
      def initialize(file_path, dictionaries)
        @file_path = file_path
        @dictionaries = dictionaries
        @incorrect_words = []
      end

      # Perform the spellcheck on the file
      def spellcheck
        lines = ::File.open(@file_path).readlines
        lines.each_with_index do |line, line_index|
          check_line(line, line_index + 1)
        end
        @incorrect_words
      end

      # Tokenize a line, i.e. split words of a line.
      # @param [String] word_line A line of a text.
      # @return [Array<String>] Words of the word_line.
      def self.word_splitter(word_line)
        word_line.split(/[_\-\s\d]+|(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])|\W+/).map(&:downcase)
      end

      private

      #
      # Check if a line is correct.
      # Initializes #incorrect_words.
      #
      # @param [String] line Line of a file.
      # @param [Integer] line_number Line number inside the parent file.
      def check_line(line, line_number)
        line_words = self.class.word_splitter(line)
        line_words.each do |word|
          word_is_right, spell_checked_word = check_word(word, line_number)
          next if word_is_right.is_a?(TrueClass)
          @incorrect_words << spell_checked_word
        end
      end

      # Check if a word is correct according to at least one dictionary.
      # @param [String] word Word in a line of a file.
      # @param [Integer] line_number Line number inside the parent file.
      # @return [[FalseClass, AlfonsoX::SpellChecker::Word], [TrueClass, nil]]
      #         The first case is returned if the word is wrong:
      #           return a pair of false, and a #AlfonsoX::#SpellChecker::#Word.
      #         The second case is returned if the word is right:
      #           return a pair of true, and nil.
      def check_word(word, line_number)
        spell_checked_word = AlfonsoX::SpellChecker::Word.new(word, line_number, @dictionaries)
        word_is_right = spell_checked_word.check
        return [true, nil] if word_is_right
        [false, spell_checked_word]
      end
    end
  end
end
