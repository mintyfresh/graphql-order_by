# frozen_string_literal: true

module GraphQL
  module OrderBy
    class DirectionType < GraphQL::Schema::Enum
      graphql_name 'OrderByDirection'

      value 'ASC', value: :asc
      value 'DESC', value: :desc

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
