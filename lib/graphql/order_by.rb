# frozen_string_literal: true

require_relative 'order_by/version'

require 'graphql'

module GraphQL
  module OrderBy
    autoload :DirectionType, 'graphql/order_by/direction_type'
    autoload :DSL, 'graphql/order_by/dsl'
    autoload :Extension, 'graphql/order_by/extension'
  end
end
