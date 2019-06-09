# frozen_string_literal: true

require 'nokogiri'

# Alfonso X module
module AlfonsoX
  # Spell checker
  module SpellChecker
    # Alfonso X dictionary
    module Dictionary
      # Rubymine dictionary loader
      class Rubymine
        # Default directory where the XML RubyMine dictionary file should be
        DEFAULT_PATH = '.idea/dictionaries'
        attr_reader :path

        def initialize(path = nil)
          @path = path || DEFAULT_PATH
          load_dictionaries
        end

        def self.from_config(yml_config)
          new(yml_config.fetch('path') { DEFAULT_PATH })
        end

        def word_present?(word)
          @words.include?(word.downcase)
        end

        def similar_words(_word)
          []
        end

        private

        def load_dictionaries
          @words = Set.new
          Dir.glob("#{@path}/*.xml") do |xml_file_path|
            xml_file_contents = ::File.open(xml_file_path).read
            xml_doc = ::Nokogiri::XML(xml_file_contents)
            xml_doc.css('w').each do |word|
              @words.add(word.content.downcase)
            end
          end
          @words
        end
      end
    end
  end
end
