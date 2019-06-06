# frozen_string_literal: true

# Alfonso X module
module AlfonsoX
  module SpellChecker
    # Each of the spell-checked words
    class Word
      attr_reader :word, :line

      # Initialize a spell-checked word.
      # @param [String] word Word to be spell-checked.
      # @param [Integer] line Line number this word belongs to.
      # @param [Array<AlfonsoX::SpellChecker::Dictionary::Hunspell, AlfonsoX::SpellChecker::Dictionary::Rubymine>]
      #        dictionaries Array of dictionaries that will be used to check if this word spelling is right.
      def initialize(word, line, dictionaries)
        @word = word
        @line = line
        @dictionaries = dictionaries
        @right = nil
      end

      # Check if the word is right.
      # Assigns the Word#right attribute.
      # @return [Boolean] true if the word is rightfully written, false otherwise.
      def check
        @dictionaries.each do |dictionary|
          @right = check_for_dictionary(dictionary)
          return true if @right
        end
        false
      end

      private

      # Check if the word is rightfully written for a dictionary.
      # @param [Array<AlfonsoX::SpellChecker::Dictionary::Hunspell, AlfonsoX::SpellChecker::Dictionary::Rubymine>]
      #        dictionaries Array of dictionaries that will be used to check if this word spelling is right.
      # @return [Boolean] true if the word is rightfully written for the passed dictionary, false otherwise.
      def check_for_dictionary(dictionary)
        right = dictionary.word_present?(@word)
        return true if right
        false
      end
    end
  end
end
