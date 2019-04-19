# Proforma Extended Evaluator

[![Gem Version](https://badge.fury.io/rb/proforma-extended-evaluator.svg)](https://badge.fury.io/rb/proforma-extended-evaluator) [![Build Status](https://travis-ci.org/bluemarblepayroll/proforma-extended-evaluator.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/proforma-extended-evaluator) [![Maintainability](https://api.codeclimate.com/v1/badges/79e66b596906f633bc95/maintainability)](https://codeclimate.com/github/bluemarblepayroll/proforma-extended-evaluator/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/79e66b596906f633bc95/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/proforma-extended-evaluator/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The core Proforma library intentionally ships with a very weak evaluator.  Custom text templating and value resolution is not part of the core library's domain.  This library fills that void.  The goals of this library are to provide:

1. Nested value resolution using dot-notation: `demographics.contact.first_name`
2. Indifferent object types for value resolution: Hash, OpenStruct, Object subclass, etc.
3. Rich text templating: `{demo.last}, {demo.first} {demo.middle}`
4. Customizable formatting:
  * `{amount::currency}` -> `$12,345.67 USD`
  * `{dob::date}` -> `2/4/1976`
  * `{user_count::number::0}` -> `12,400,569`
  * `{logins_per_day::number::2}` -> `76,004.45`

## Installation

To install through Rubygems:

````
gem install install proforma-extended-evaluator
````

You can also add this to your Gemfile:

````
bundle add proforma-extended-evaluator
````

## Examples

TODO

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check proforma-extended-evaluator.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/proforma-extended-evaluator.git)
4. Navigate to the root folder (cd proforma)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````
bundle exec guard
````

Also, do not forget to run Rubocop:

````
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update `lib/proforma/extended_evaluator/version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Build the project locally: `gem build proforma-extended-evaluator`
7. Publish package to RubyGems: `gem push proforma-extended-evaluator-X.gem` where X is the version to push
8. Tag master with new version: `git tag <version>`
9. Push tags remotely: `git push origin --tags`

## License

This project is MIT Licensed.
