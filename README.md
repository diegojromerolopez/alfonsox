# Alfonso X

[![Gem Version](https://badge.fury.io/rb/alfonsox.svg)](https://badge.fury.io/rb/alfonsox)
[![Build Status](https://travis-ci.org/diegojromerolopez/alfonsox.svg?branch=master)](https://travis-ci.org/diegojromerolopez/alfonsox)
[![Maintainability](https://api.codeclimate.com/v1/badges/053783a6bcd2404df5b1/maintainability)](https://codeclimate.com/github/diegojromerolopez/alfonsox/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/053783a6bcd2404df5b1/test_coverage)](https://codeclimate.com/github/diegojromerolopez/alfonsox/test_coverage)

<p align="center">
  <img width="250" src="https://github.com/diegojromerolopez/alfonsox/raw/master/resources/images/alfonsox.jpg">
</p>

A simple spellchecking tool to make easy the spellchecking of code files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alfonsox'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install alfonsox
```

## Setup

Make sure you have [hunspell](http://hunspell.github.io/) installed
in your system.

No installation of dictionaries is required as this package already contains
LibreOffice dictionaries from
[LibreOffice dictionaries repository](https://github.com/LibreOffice/dictionaries).

## Usage

### Terminal

#### Define a configuration file

Create a YML file with the following structure to set up configuration of the spellchecking process:

```yaml

# Paths the files to ve spellchecked are
Paths:
  - 'lib/**.rb'
  - 'test/**.rb'
  - '... other paths that will be spellcheck'

# Dictionaries, choose one or all of these options
#Note the name of these subsections can be customized,
# i.e. instead of MyEnglishDictionaryFromLocalPath you can write
# LocalDictionary, for example.
Dictionaries:

  # Use a hunspell dictionary included in your project
  MyEnglishDictionaryFromLocalPath:
    type: 'hunspell'
    # Local hunspell dictionaries (.aff and .dic files)
    path: 'my-local-path/dictionaries'
    language: 'en_US'
  
  # Use a hunspell dictionary from this gem
  MyEnglishDictionaryFromGem:
      type: 'hunspell'
      language: 'en_US'
  
  # If you use Rubymine, it is very useful to
  # include your custom dictionary
  MyRubymineDictionary:
    type: 'rubymine'
    # Optional, by default is '.idea/dictionary.xml'
    path: '.idea/dictionary.xml'

  # Include in this section a file path with a list of custom words or words
  # Note the file must contain a word per line
  # that do not appear in other dictionaries
  WordListFileictionary:
   type: 'word_list'
   path: 'your/word/list/file/path'
 
  # Include in this section a list of custom words or words
  # that do not appear in other dictionaries
  WordListDictionary:
   type: 'word_list'
   word_list:
    - 'alfonso'
    - 'babik'
    - 'queryset'
    - 'txt'
```

e.g.

```yaml
Paths:
  - 'app/*/**.rb'
  - 'lib/**.rb'
  - 'test/**.rb'
Dictionaries:
  EnglishDictionaryFromGem:
      type: 'hunspell'
      language: 'en_US'
  RubymineDictionary:
    type: 'rubymine'
```

#### Command line tool

Just call **bundle exec alfonsox** and it should work fine, informing of any orthographic error in your code files.

The arguments must be the full paths of the file to be checked. If no arguments are passed to this tool, all files
that fulfill the paths defined in the configuration file will be checked.

##### Output

###### Successful Output

Note the output is written in standard output (STDOUT).

```bash
$ bundle exec alfonsox file1 file2 #...
✔ Code is spell-checked correctly
```

Note the exit code is 0

```bash
$ echo $?
0
```

###### Non-successful Output

Note the output is written in error standard output (STDERR).

```bash
$ bundle exec alfonsox file1 file2 #...
/Users/diegoj/proyectos/blobik/app/models/post.rb:2 incorrektword
✗ Errors in code spellchecking
```

Note the exit code is 1

```bash
$ echo $?
1
```

### Overcommit integration

Easiest way of use this project is to use [Overcommit](https://github.com/sds/overcommit).
For those of you that don't know it, it is a project whose aim is to provide developers
with tools to check code quality easily.

It has a
[CodeSpellCheck](https://github.com/sds/overcommit/blob/master/lib/overcommit/hook/pre_commit/code_spell_check.rb)
pre-commit hook that accepts an Alfonso X configuration, by default is:

```yml
Paths:
- 'app/*/**.rb'
- 'lib/**.rb'
- 'test/**.rb'
Dictionaries:
  EnglishDictionaryFromGem:
    type: 'hunspell'
    language: 'en_US'
  RubymineDictionary:
    type: 'rubymine'
```

If you want to overwrite it, create an **.alfonsox.yml** file in your
home directory and write your custom spell-check configuration there.

### From code

#### Load dictionaries

```ruby
# Load Hunspell dictionary from your system
# Make sure you have installed your dictionaries 
dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new('en_US')

# Or, alternatively you can load Hunspell dictionary from a local path
# Make sure the following files exist:
# - YOUR_PATH/dictionaries/en_US/en_US.aff 
# - YOUR_PATH/dictionaries/en_US/en_US.dic 
dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
  'en_US', "YOUR_PATH/dictionaries"
)
```

#### Spellcheck some files

```ruby
dictionaries = [
  AlfonsoX::SpellChecker::Dictionary::Hunspell.new('en_US'),
  AlfonsoX::SpellChecker::Dictionary::Hunspell.new('es_US')
]
# Create spellchecker
spellchecker = AlfonsoX::SpellChecker::Main.new(
  "directory/with/files/**/*.rb",
  dictionaries
)

# Check the files
incorrect_words = spellchecker.check

# incorrect_words is a dict where
# the keys area the path of each one of the files that have at least one wrong word
# and the values are a list of incorrect words 
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/diegojromerolopez/alfonsox]([https://github.com/diegojromerolopez/alfonsox).

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

To sum up, we only talk about this software and respect each other.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

All dictionaries included in [resources/dictionaries/hunspell](resources/dictionaries/hunspell) are part of the LibreOffice hunspell dictionaries. Each one has its own license.
Visit [LibreOffice dictionaries repository](https://github.com/LibreOffice/dictionaries) for more information.

The en_US dictionary included in the tests has MIT and BSD license and has been copied from
[Titus Wormer's dictionary repository](https://github.com/wooorm/dictionaries/tree/master/dictionaries/en-US).

[King Alfonso X image is Public Domain](https://commons.wikimedia.org/wiki/File:Retrato_de_Alfonso_X.jpg).

RubyMine is a trademark of JetBrains. This project is no way endorsed, supported by or related with JetBrains.

## Code of Conduct

Everyone interacting in the Alfonso X project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/diegojromerolopez/alfonsox/blob/master/CODE_OF_CONDUCT.md).

## Contributions

I accept contribution and feature requests via PR (GitHub pull requests).

Create an issue or send me an email before making a PR
if you are unsure about if your PR is going to be accepted.

Any suggestion, issue or constructive criticism is also welcomed.

## Why the name?

[Alfonso X](https://en.wikipedia.org/wiki/Alfonso_X_of_Castile), called *The Wise*,
was a king that reigned [Castile](https://en.wikipedia.org/wiki/Crown_of_Castile) (in Spain) during medieval times.
He was a patron of the languages and pushed for the first orthography rules of Spanish.