# frozen_string_literal: true

require 'nokogiri'

# Alfonso X module
module AlfonsoX
  module SpellChecker
    module Dictionary
      # Rubymine dictionary loader
      class Rubymine
        def initialize(path = nil)
          @path = path || '.idea/dictionaries'
          load_dictionaries
        end

        def word_present?(word)
          @words.include?(word.upcase)
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
            xml_doc.xpath('//w').each do |word|
              @words.add(word.content.upcase)
            end
          end
          @words
        end
      end
    end
  end
end
