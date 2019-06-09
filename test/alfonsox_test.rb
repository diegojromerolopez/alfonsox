# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

# Basic tests for this library
class AlfonsoXTest < Minitest::Test
  # A short fragment of Pride & Prejudice by Jane Austen
  RESOURCE_PATH = "#{__dir__}/resources"

  # Use the hunspell system dictionary to spellcheck a short fragment of the sample text with en_US localization
  def test_hunspell_system_dictionary
    test_file_path = "#{RESOURCE_PATH}/pride_1.txt"
    dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new('en_US')
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 1, incorrect_words[test_file_path].length
  end

  # Use the hunspell dictionary stored in test/dictionaries/en_US to spellcheck
  # a short fragment of the sample text with en_US localization (alternative call method)
  def test_hunspell_local_dictionary_directory
    test_file_path = "#{RESOURCE_PATH}/pride_1.txt"
    dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
      'en_US', "#{__dir__}/dictionaries"
    )
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 1, incorrect_words[test_file_path].length
  end

  # Use the rubymine dictionary stored in test/dictionaries/test.xml to spellcheck
  # a short fragment of the sample text.
  # Note there is no language here, because the dictionary is not based on language
  # but in the words added by the user.
  def test_rubymine_dictionary
    test_file_path = "#{RESOURCE_PATH}/pride_1.txt"
    dictionary = AlfonsoX::SpellChecker::Dictionary::Rubymine.new("#{__dir__}/dictionaries")
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 64, incorrect_words[test_file_path].length
  end

  # Test that several dictionaries can be loaded
  def test_several_dictionaries
    test_file_path = "#{RESOURCE_PATH}/pride_1.txt"
    hunspell_dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
      'en_US', "#{__dir__}/dictionaries"
    )
    rubymine_dictionary = AlfonsoX::SpellChecker::Dictionary::Rubymine.new("#{__dir__}/dictionaries")
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      [hunspell_dictionary, rubymine_dictionary]
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 1, incorrect_words[test_file_path].length
    assert_equal 'neighbourhood', incorrect_words[test_file_path][0].word
    assert_equal 5, incorrect_words[test_file_path][0].line
  end

  def test_code_file
    test_file_path = "#{RESOURCE_PATH}/babik.rb"
    hunspell_dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new('en_US')
    rubymine_dictionary = AlfonsoX::SpellChecker::Dictionary::Rubymine.new("#{__dir__}/dictionaries")
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      [hunspell_dictionary, rubymine_dictionary]
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 15, incorrect_words[test_file_path].length
  end

  def test_config_load
    spellchecker = AlfonsoX::SpellChecker::Main.from_config("#{__dir__}/resources/config.yml")
    # Check the spellchecked paths
    assert_equal 2, spellchecker.paths.length
    assert_equal 'lib/**.rb', spellchecker.paths[0]
    assert_equal 'test/**.rb', spellchecker.paths[1]

    # Dictionaries assertions
    assert_equal 5, spellchecker.dictionaries.length

    hunspell_dictionary1 = spellchecker.dictionaries[0]
    assert_equal 'en_US', hunspell_dictionary1.language
    assert_equal 'test/dictionaries', hunspell_dictionary1.path

    hunspell_dictionary2 = spellchecker.dictionaries[1]
    assert_equal 'en_US', hunspell_dictionary2.language
    assert_equal AlfonsoX::SpellChecker::Dictionary::Hunspell::DEFAULT_PATH, hunspell_dictionary2.path

    rubymine_dictionary = spellchecker.dictionaries[2]
    assert_equal AlfonsoX::SpellChecker::Dictionary::Rubymine::DEFAULT_PATH, rubymine_dictionary.path
  end
end
