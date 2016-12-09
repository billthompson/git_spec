# GitSpec

Execute your test runner for files in your git diff.

Examples:

    M lib/git_spec.rb

GitSpec will expect the test to be defined at spec/git_spec_spec.rb

    M lib/git_spec/file.rb

GitSpec will expect the test to be defined at spec/git_spec/file_spec.rb


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git_spec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_spec

## Usage

    $ gspec spec [options]
    
Options:

--command="bundle exec rspec" - The command to execute your test runner. This command will receive a single argument of space-delimited file paths.  

--src_root="lib/" - The primary source directory for your application. For Rails, set to "app/". 

--log_level="Logger::INFO" - The log level.   

--dry_run="true", Aliases: -d - Should the test runner be executed? When in dry run mode, the list of files that would be sent to the test runner will be output.   
    

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/billthompson/git_spec. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

