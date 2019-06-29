# frozen_string_literal: true

require 'nokogiri'

# Alfonso X module
module AlfonsoX
  # Spell checker
  module SpellChecker
    # Alfonso X dictionary
    module Dictionary
      # Default dictionary loader
      class Default
        # Ruby keywords
        KEYWORDS = %w[
          ENCODING
          LINE
          FILE
          BEGIN
          END
          alias
          and
          begin
          break
          case
          class
          def
          defined?
          do
          else
          elsif
          end
          ensure
          false
          for
          if
          in
          module
          next
          nil
          not
          or
          redo
          rescue
          retry
          return
          self
          super
          then
          true
          undef
          unless
          until
          when
          while
          yield
        ].freeze

        # Other common but erroneous words in the Ruby-development world
        OTHERS = %w[
          asc
          autorun
          autotest
          bigint
          config
          const
          cov
          datetime
          desc
          dir
          env
          formatter
          klass
          rb
          hunspell
          mixin
          param
          sym
          rubymine
          simplecov
          unshift
          xml
          yml
        ].freeze

        # Initialize this default dictionary for Ruby code
        def initialize
          @words = (KEYWORDS + OTHERS).map(&:downcase)
        end

        # Check if a word is present in the dictionary.
        # @param [String] word Word to be checked.
        # @return [Boolean] true if the word is in the dictionary, false otherwise.
        def word_present?(word)
          @words.include?(word.downcase)
        end
      end
    end
  end
end
