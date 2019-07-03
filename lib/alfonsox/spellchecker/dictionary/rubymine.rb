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

        # Initialize Rubymine dictionary
        # If path is not present, it will be loaded from #DEFAULT_PATH.
        def initialize(path = nil)
          @path = path || DEFAULT_PATH
          load_dictionaries
        end

        # Load configuration from YML
        def self.from_config(yml_config)
          new(yml_config.fetch('path') { DEFAULT_PATH })
        end

        # Inform if a word is present in this dictionary.
        def word_present?(word)
          @words.include?(word.downcase)
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
