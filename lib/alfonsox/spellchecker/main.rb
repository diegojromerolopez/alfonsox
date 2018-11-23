# frozen_string_literal: true

require 'alfonsox/spellchecker/file'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    class Main
      def initialize(paths, dictionary)
        paths = [paths] if paths.is_a?(String)
        @paths = paths
        @dictionary = dictionary
      end

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

      def check_file(file)
        spell_checked_file = AlfonsoX::SpellChecker::File.new(file, @dictionary)
        spell_checked_file.spellcheck
        spell_checked_file.incorrect_words
      end
    end
  end
end