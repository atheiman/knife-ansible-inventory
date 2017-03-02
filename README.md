# knife-ansible-inventory

Custom [Chef knife plugin](https://docs.chef.io/plugin_knife_custom.html) that returns Chef nodes in a JSON format suitable for [a custom Ansible inventory](http://docs.ansible.com/ansible/dev_guide/developing_inventory.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'knife-ansible-inventory'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knife-ansible-inventory

## Usage

```shell
$ knife ansible inventory
    --group-by-attribute ATTRIBUTE
    --host-attribute ATTRIBUTE
    --hostvars RETURNED_KEY=ATTRIBUTE.PATH[,RETURNED_KEY=ATTRIBUTE.PATH]
    --query QUERY
    --help
```

See the [`spec/`](/spec/) directory for examples of commands and their output JSON.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/atheiman/knife-ansible-inventory.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
