# frozen_string_literal: true

module GraphQL
  module OrderBy
    module DSL
      # @param name [String]
      # @param default [Boolean]
      # @yieldparam direction [String]
      # @yieldreturn [ActiveRecord::Relation]
      # @return [void]
      def order_by(name, default: false, **options, &block)
        raise ArgumentError, "#{name}.order_by given a `value` argument, but it unsupported" if options.key?(:value)

        value(name, **options, value: block)
        default_order_by(name) if default
      end

      # @param name [String]
      # @return [void]
      def default_order_by(name)
        define_singleton_method(:default_value) { values[name].value }
      end
    end
  end
end
