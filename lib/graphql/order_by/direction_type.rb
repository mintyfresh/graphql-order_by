# frozen_string_literal: true

module GraphQL
  module OrderBy
    class DirectionType < GraphQL::Schema::Enum
      graphql_name 'OrderByDirection'

      value 'ASC', value: :asc do
        description 'Indicates that the results should be sorted in ascending order, from smallest to largest.'
      end

      value 'DESC', value: :desc do
        description 'Indicates that the results should be sorted in descending order, from largest to smallest.'
      end

      # @return [Symbol]
      def self.default_value
        asc
      end

      # @return [Symbol]
      def self.asc
        values['ASC'].value
      end

      # @return [Symbol]
      def self.desc
        values['DESC'].value
      end
    end
  end
end
