# Alfonso X

**NOT READY FOR USE IN PRODUCTION**.

## What's this?

A simple spellchecking tool to make easy the spellchecking of code files.

The aim is to use it with overcommit and automatically spellcheck code files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alfonsox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alfonsox

## Usage

### Load dictionary

```ruby
# Load dictionary
dictionary = AlfonsoX::SpellChecker::Dictionary::Hunspell.new(
'en_US', "#{__dir__}/dictionaries/en_US"
)

# Create spellchecker
spellchecker = AlfonsoX::SpellChecker::Main.new(
  "directory/with/files/**/*.rb",
  dictionary
)

# Check the files
incorrect_words = spellchecker.check

# incorrect_words is a dict where
# the keys area the path of each one of the files that have at least one wrong word
# and the values are a list of incorrect words 
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/alfonsox. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

The en_US dictionary included in the tests has MIT and BSD license and has been copied from [Titus wormer's dictionary repository](https://github.com/wooorm/dictionaries/tree/master/dictionaries/en-US).

## Code of Conduct

Everyone interacting in the Alfonso X project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/alfonsox/blob/master/CODE_OF_CONDUCT.md).

## Why the name?

[Alfonso X](https://en.wikipedia.org/wiki/Alfonso_X_of_Castile), called *The Wise*, was a king that reigned [Castille](https://en.wikipedia.org/wiki/Crown_of_Castile) (in Spain) during medieval times.
He was a patron of the languages and pushed for the first ortography rules of Spanish.