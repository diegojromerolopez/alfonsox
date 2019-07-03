# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

# Dictionary tests for this library
class DictionaryTest < Minitest::Test
  # Resources used for this test
  RESOURCES_PATH = "#{__dir__}/resources"

  # Test load of word list dictionary from YML configuration
  def test_load_dictionaries
    spellchecker = AlfonsoX::SpellChecker::Main.from_config("#{RESOURCES_PATH}/config.yml")
    assert_equal 6, spellchecker.dictionaries.length

    word_list_file_dictionary = spellchecker.dictionaries[3]
    word_list_dictionary = spellchecker.dictionaries[4]

    assert word_list_file_dictionary.is_a?(AlfonsoX::SpellChecker::Dictionary::WordListFile)
    assert_equal 59, word_list_file_dictionary.words.length
    assert word_list_dictionary.is_a?(AlfonsoX::SpellChecker::Dictionary::WordList)
    assert_equal 4, word_list_dictionary.words.length
  end
end