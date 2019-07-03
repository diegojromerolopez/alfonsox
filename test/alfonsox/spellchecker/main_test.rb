# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

# Main tests for this library
class MainTest < Minitest::Test
  # Resources used for this test
  RESOURCES_PATH = "#{__dir__}/resources"

  # Dictionary path
  DICTIONARIES_PATH = "#{RESOURCES_PATH}/dictionaries"

  # Use the hunspell system dictionary to spellcheck a short fragment of the sample text with en_US localization
  def test_hunspell_gem_dictionary
    test_file_path = "#{RESOURCES_PATH}/pride_1.txt"
    dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new('en_US')
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words_on_all_files = spellchecker.check
    incorrect_words_on_pride_file = spellchecker.check([test_file_path])
    assert_equal 1, incorrect_words_on_all_files.length
    assert_equal 1, incorrect_words_on_all_files[test_file_path].length
    assert_equal 1, incorrect_words_on_pride_file.length
    assert_equal 1, incorrect_words_on_pride_file[test_file_path].length

    assert_raises do
      spellchecker.check(['non_existant'])
    end
  end

  # Use the hunspell dictionary stored in test/dictionaries/en_US to spellcheck
  # a short fragment of the sample text with en_US localization (alternative call method)
  def test_hunspell_local_dictionary_directory
    test_file_path = "#{RESOURCES_PATH}/pride_1.txt"
    dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
      'en_US', DICTIONARIES_PATH
    )
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 1, incorrect_words[test_file_path].length
  end

  def test_hunspell_non_existent_local_dictionary_directory
    assert_raises do
      AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
        'en_NZ'
      )
    end
  end

  # Use the rubymine dictionary stored in test/dictionaries/test.xml to spellcheck
  # a short fragment of the sample text.
  # Note there is no language here, because the dictionary is not based on language
  # but in the words added by the user.
  def test_rubymine_dictionary
    test_file_path = "#{RESOURCES_PATH}/pride_1.txt"
    dictionary = AlfonsoX::SpellChecker::Dictionary::Rubymine.new(DICTIONARIES_PATH)
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 64, incorrect_words[test_file_path].length
  end

  # Use the short text as a word list dictionary and check it works.
  def test_word_list_dictionary_success
    test_file_path = "#{RESOURCES_PATH}/pride_1.txt"
    test_file_words = ::File.read(test_file_path).split(/[^\w]+/)
    dictionary = AlfonsoX::SpellChecker::Dictionary::WordList.new(test_file_words)
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 0, incorrect_words.length
  end

  # Check a short text with a word list file dictionary and check it works.
  def test_word_list_file_dictionary
    test_file_path = "#{RESOURCES_PATH}/pride_1.txt"
    word_list_file_path = "#{DICTIONARIES_PATH}/word_list.txt"
    dictionary = AlfonsoX::SpellChecker::Dictionary::WordListFile.new(word_list_file_path)
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 0, incorrect_words.length
  end

  # Test that several dictionaries can be loaded
  def test_several_dictionaries
    test_file_path = "#{RESOURCES_PATH}/pride_1.txt"
    hunspell_dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
      'en_US', DICTIONARIES_PATH
    )
    rubymine_dictionary = AlfonsoX::SpellChecker::Dictionary::Rubymine.new(DICTIONARIES_PATH)
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

  # Test spell checking of code file
  def test_code_file
    test_file_path = "#{RESOURCES_PATH}/babik.rb"
    hunspell_dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new('en_US')
    rubymine_dictionary = AlfonsoX::SpellChecker::Dictionary::Rubymine.new(DICTIONARIES_PATH)
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      test_file_path,
      [hunspell_dictionary, rubymine_dictionary]
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 15, incorrect_words[test_file_path].length
  end

  # Test configuration load
  def test_config_load
    spellchecker = AlfonsoX::SpellChecker::Main.from_config("#{RESOURCES_PATH}/config.yml")
    # Check the spell-checked paths
    assert_equal 2, spellchecker.paths.length
    assert_equal 'lib/**.rb', spellchecker.paths[0]
    assert_equal 'test/**.rb', spellchecker.paths[1]

    # Dictionaries assertions
    assert_equal 6, spellchecker.dictionaries.length

    hunspell_dictionary1 = spellchecker.dictionaries[0]
    assert_equal 'en_US', hunspell_dictionary1.language
    assert_equal 'test/alfonsox/spellchecker/resources/dictionaries', hunspell_dictionary1.path

    hunspell_dictionary2 = spellchecker.dictionaries[1]
    assert_equal 'en_US', hunspell_dictionary2.language
    assert_equal AlfonsoX::SpellChecker::Dictionary::Hunspell::DEFAULT_PATH, hunspell_dictionary2.path

    rubymine_dictionary = spellchecker.dictionaries[2]
    assert_equal AlfonsoX::SpellChecker::Dictionary::Rubymine::DEFAULT_PATH, rubymine_dictionary.path
  end

  # Test a configuration with bad type of dictionary
  def test_bad_config_load
    exception = assert_raises(Exception) do
      AlfonsoX::SpellChecker::Main.from_config("#{RESOURCES_PATH}/bad_config.yml")
    end
    assert_equal 'Dictionary type this-dictionary-type-does-not-exist is not recognized', exception.message
  end
end
