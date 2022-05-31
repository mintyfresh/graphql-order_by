# frozen_string_literal: true

module GraphQL
  module OrderBy
    class Extension < GraphQL::Schema::FieldExtension
      def apply
        order_by_type = options[:type]

        default_order_by = options.fetch(:default) { order_by_type.default_value }
        default_order_by_direction = options.fetch(:default_direction) { DirectionType.default_value }

        field.argument(:order_by, order_by_type, required: false, default_value: default_order_by)
        field.argument(:order_by_direction, DirectionType, required: false, default_value: default_order_by_direction)
      end

      def resolve(object:, arguments:, **)
        order_by = arguments[:order_by]
        order_by_direction = arguments[:order_by_direction]
        order_by_scope = order_by.call(order_by_direction) if order_by

        yield(object, arguments.except(:order_by, :order_by_direction).merge(order_by_scope: order_by_scope))
      end
    end
  end
end
