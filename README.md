# Alfonso X

[![Build Status](https://travis-ci.org/diegojromerolopez/alfonsox.svg?branch=master)](https://travis-ci.com/diegojromerolopez/alfonsox)
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

#### Rake task

To use the rake task, you have to include the two following lines
in your project's Rakefile:

```ruby
alfonsox_gem = Gem::Specification.find_by_name('alfonsox')
load("#{alfonsox_gem.gem_dir}/Rakefile")
```

That two lines load all Alfonso X tasks' in your Rakefile.

Our aim is to use **alfonsox:spellcheck** task.

##### Default configuration

There is a [default configuration](/resources/configurations/default.yml)
that will check US-English spelling and your RubyMine dictionary with your
custom spellings.

```bash
bundle exec rake alfonsox:spellcheck
```

##### Custom configuration

Copy the [default configuration](/resources/configurations/default.yml)
to your project root directory and modify it

```bash
bundle exec rake alfonsox:spellcheck[<path/where/alfonsox.yml/file/is>]
```

e.g.:

```bash
bundle exec rake alfonsox:spellcheck[.alfonsox.yml]
```

The rake task will output the spell checking errors, e.g.:

```bash
$ bundle exec rake alfonsox:spellcheck[./test/resources/config.yml]
Starting spellcheck using configuration ./test/resources/config.yml
/Users/diegoj/proyectos/alfonsox/test/alfonsox_test.rb:8 jane
/Users/diegoj/proyectos/alfonsox/test/alfonsox_test.rb:8 austen
/Users/diegoj/proyectos/alfonsox/test/alfonsox_test.rb:70 neighbourhood
```

### Overcommit integration

[Overcommit](https://github.com/sds/overcommit)
is a project whose aim is to provide developers
with tools to check code quality easily.

[Define a new pre-commit hook in your repository](https://github.com/sds/overcommit#repo-specific-hooks):

Add a file **.git-hooks/pre_commit/alfonsox.rb** with the following contents:

```ruby
# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  #
  # Spell check of the code.
  #
  class AlfonsoX < Base
    def run
      # Create default file config if it does not exist

      # Run rake spellcheck task
      args = flags + applicable_files
      result = execute('bundle exec rake alfonsox:spellcheck[.alfonsox.yml]', args: args)
      spellchecking_errors = result.split('\n')

      # Check the if there are spelling errors
      return :pass if spellchecking_errors.length.zero?

      error_messages(spellchecking_errors)
    end

    private

    # Create the error messages
    def error_messages(spellchecking_errors)
      messages = []
      spellchecking_errors.each do |spellchecking_error_i|
        error_location, word = spellchecking_error_i.split(' ')
        error_file_path, line = error_location.split(':')
        messages << Overcommit::Hook::Message.new(
          :error, error_file_path, line, "#{error_location}: #{word}"
        )
      end
      messages
    end
  end
end
```

Make sure you have a configuration in the root directory of your project with
the name **.alfonsox.yml**:

```yml
Paths:
- '*/**.rb'
Dictionaries:
  EnglishDictionaryFromGem:
    type: 'hunspell'
    language: 'en_US'
  RubymineDictionary:
    type: 'rubymine'
  WordListDictionary:
    type: 'word_list'
    word_list:
    - 'alfonso'
```

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

Any constructive criticism is welcomed.

## Why the name?

[Alfonso X](https://en.wikipedia.org/wiki/Alfonso_X_of_Castile), called *The Wise*,
was a king that reigned [Castile](https://en.wikipedia.org/wiki/Crown_of_Castile) (in Spain) during medieval times.
He was a patron of the languages and pushed for the first orthography rules of Spanish.