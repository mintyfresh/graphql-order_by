# Graphql::OrderBy

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/graphql/order_by`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-order_by'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install graphql-order_by

Finally, run the install generator:

    $ bin/rails generator graphql:order_by:install

This will generate a `BaseOrderByEnum` class for your application.

## Usage

```ruby
class UserOrderByType < BaseOrderByEnum
  order_by 'ID', default: true do |direction|
    User.order(id: direction)
  end

  order_by 'USERNAME' do |direction|
    User.order(username: direction)
  end

  order_by 'SPENDING' do |direction|
    # Direction here is a mapped value coming from a GraphQL enum
    # Its possible values are `:asc` and `:desc`
    User.joins(:purchases).group(:id).order(Purchase.arel_table[:total].sum.send(direction))
  end
end
```

```ruby
class UserGroupType < BaseObject
  field :id, ID
  # ...
  field :users, [UserType] do
    extension GraphQL::OrderBy::Extension, type: UserOrderByType
  end

  def users(order_by_scope:)
    # Here `order_by_scope` is the ActiveRecord::Relation from the `UserOrderByType`
    # Merging it with the `users` relationship from the object will apply the mapped ordering
    object.users.merge(order_by_scope)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mintyfresh/graphql-order_by.
