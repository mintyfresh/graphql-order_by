# frozen_string_literal: true

module Types
  class BaseOrderByEnum < BaseEnum
    extend GraphQL::OrderBy::DSL
  end
end
