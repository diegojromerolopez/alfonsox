# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

# Basic tests for this library
class AlfonsoXTest < Minitest::Test
  # A short fragment of Pride & Prejudice by Jane Austen
  SAMPLE_TEXT_PATH = "#{__dir__}/resources/pride_1.txt"

  # Use the hunspell system dictionary to spellcheck a short fragment of the sample text with en_US localization
  def test_hunspell_system_dictionary
    dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new('en_US')
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      SAMPLE_TEXT_PATH,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 4, incorrect_words[SAMPLE_TEXT_PATH].length
  rescue RuntimeError => exception
    puts "#{exception}. Ignoring test."
  end

  # Use the hunspell dictionary stored in test/dictionaries/en_US to spellcheck
  # a short fragment of the sample text with en_US localization
  def test_hunspell_local_dictionary_prefix
    dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
      'en_US', "#{__dir__}/dictionaries/en_US"
    )
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      SAMPLE_TEXT_PATH,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 4, incorrect_words[SAMPLE_TEXT_PATH].length
  end

  # Use the hunspell dictionary stored in test/dictionaries/en_US to spellcheck
  # a short fragment of the sample text with en_US localization (alternative call method)
  def test_hunspell_local_dictionary_directory
    dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
      'en_US', "#{__dir__}/dictionaries"
    )
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      SAMPLE_TEXT_PATH,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 4, incorrect_words[SAMPLE_TEXT_PATH].length
  end

  # Use the rubymine dictionary stored in test/dictionaries/test.xml to spellcheck
  # a short fragment of the sample text.
  # Note there is no language here, because the dictionary is not based on language
  # but in the words added by the user.
  def test_rubymine_dictionary_gb
    dictionary = AlfonsoX::SpellChecker::Dictionary::Rubymine.new("#{__dir__}/dictionaries")
    spellchecker = AlfonsoX::SpellChecker::Main.new(
      SAMPLE_TEXT_PATH,
      dictionary
    )
    incorrect_words = spellchecker.check
    assert_equal 1, incorrect_words.length
    assert_equal 69, incorrect_words[SAMPLE_TEXT_PATH].length
  end
end
