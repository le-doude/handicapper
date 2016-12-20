# Handicapper

This gem provides a quick API to calculate handicaps according to the USGA official algorithm
http://golfsoftware.com/hsd/golf-handicap-formula.html

## Status

[![Build Status](https://travis-ci.org/le-doude/handicapper.svg?branch=master)](https://travis-ci.org/le-doude/handicapper)
[![Code Climate](https://codeclimate.com/github/le-doude/handicapper/badges/gpa.svg)](https://codeclimate.com/github/le-doude/handicapper)
[![Issue Count](https://codeclimate.com/github/le-doude/handicapper/badges/issue_count.svg)](https://codeclimate.com/github/le-doude/handicapper)
[![Test Coverage](https://codeclimate.com/github/le-doude/handicapper/badges/coverage.svg)](https://codeclimate.com/github/le-doude/handicapper/coverage)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'handicapper', github: 'le-doude/handicapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install handicapper

## Usage

This is meant to be an easy API to help you calculate your handicap.
It use the most bare data structures to do it.

Classic use:

```ruby
 previous_rounds = # if you have some previous handicap differentials load them here in an Array
 calculator = Handicapper.calculator(previous_rounds)
 
 # This is the settings for Ko'olau golf course from the gold/tournament tees.
 round_settings = Handicapper.round_settings(
  153, # course rating
  78.2, # slope rating
  [5,4,4,3,4,4,5,3,4,4,5,4,3,4,4,5,3,4] # par for each holes in order of play
 )
 # Your round has to be in the same order as the par scores above
 my_round = [9, 6, 7, 4, 4, 3, 8, 7, 7, 6, 6, 4, 3, 4, 5, 8, 4, 7] # I wish
 
 # calculate returns the updated handicap after considering the submitted round
 handicap = calculator.calculate(round_settings, my_round)
 # if you do not have the hole by hole score you can use the total. The result might not be the same as with the official USGA calculations though
 handicap = calculator.calculate(round_settings, 132)
 # you can use current handicap if you have no new round but want it calculated
 handicap = calculator.current_handicap
```

If you want a handicap in line with your official USGA/R&A handicap you will need to enter all your rounds hole by hole and in chronological order of play. 
This is due to the ESC system that use your previous handicap to adjust your gross score to eliminate "anomaly" holes. 

Any suggestion about the API of this gem is welcome.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/le-doude/handicapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

