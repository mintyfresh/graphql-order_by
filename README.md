# GraphQL::OrderBy

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

    $ bin/rails generate graphql:order_by:install

This will generate a `BaseOrderByEnum` class for your application.

## Usage

```ruby
class UserOrderByType < BaseOrderByEnum
  order_by 'ID', default: true do |direction|
    User.order(id: direction)
  end

  order_by 'NAME' do |direction|
    User.order(first_name: direction, last_name: direction, id: direction)
  end

  order_by 'SPENDING' do |direction|
    # Direction here is a mapped value coming from a GraphQL enum
    # Its only possible values are `:asc` and `:desc`
    User.joins(:purchases).group(:id).order(Purchase.arel_table[:total].sum.send(direction))
  end
end
```

Each `order_by` block must accept a direction (a value of either `:asc` or `:desc`) and produce an ActiveRecord::Relation object that applies the desired ordering to a query.

Once defined, we can use this enum type by supplying it to the `GraphQL::OrderBy::Extension` field extension:

```ruby
class UserGroupType < BaseObject
  field :id, ID
  # ...
  field :users, [UserType] do
    # This extension adds two arguments to the field, equivalent to:
    #   argument :order_by, UserOrderByType, required: false, default_value: UserOrderByType.default_value
    #   argument :order_by_direction, GraphQL::OrderBy::DirectionType, required: false, default_value: :asc
    #
    # These arguments are handled internally by the extension, and are transformed into an `order_by_scope` keyword-argument for the resolver.
    extension GraphQL::OrderBy::Extension, type: UserOrderByType
  end

  def users(order_by_scope:)
    # Here `order_by_scope` is the ActiveRecord::Relation from the `UserOrderByType`
    # Merging it with the `users` relationship from the object will apply the mapped ordering
    object.users.merge(order_by_scope)
  end
end
```

The resolver method for the field will receive an `order_by_scope` argument. This argument contains the ActiveRecord::Relation object produced by the block that corresponds to the `order_by` and `order_by_direction` arguments received from the client.

The resulting GraphQL schema will look approximately like this:

```graphql
enum UserOrderBy {
  ID
  NAME
  SPENDING
}

type UserGroup {
  id: ID!
  # ...
  users(orderBy: UserOrderBy = ID, orderByDirection: OrderByDirection = ASC): [User!]!
}
```

### Generating Order-By Enums

    $ bin/rails generate graphql:order_by:enum PurchaseOrderBy

This will generate the file `app/graphql/types/purchase_order_by_type.rb`, which would look like:

```ruby
# frozen_string_literal: true

module Types
  class PurchaseOrderByType < BaseOrderByEnum
    # TODO: Add order-by values
  end
end
```

### Overriding the Default Sort Direction

The default direction can be changed to descending order by supplying a `default_direction`:

```ruby
extension GraphQL::OrderBy::Extension, type: UserOrderByType, default_direction: :desc
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mintyfresh/graphql-order_by.
