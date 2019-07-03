# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

# Main tests for this library
class MainInitializationTest < Minitest::Test
  def test_path_initialization
    paths = %w[full/path1 path2]
    dictionaries = [AlfonsoX::SpellChecker::Dictionary::Rubymine.new]
    spellchecker = AlfonsoX::SpellChecker::Main.new(paths, dictionaries)
    assert_equal paths, spellchecker.paths
    assert_equal 2, spellchecker.dictionaries.length
    assert spellchecker.dictionaries[0].is_a?(AlfonsoX::SpellChecker::Dictionary::Rubymine)
    assert spellchecker.dictionaries[1].is_a?(AlfonsoX::SpellChecker::Dictionary::Default)
  end
end