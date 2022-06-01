# frozen_string_literal: true

module Graphql
  module OrderBy
    class EnumGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_enum
        template('enum.rb.erb', "app/graphql/types/#{file_name}.rb")
      end

    private

      # @return [String]
      def class_name
        "#{name.classify.chomp('Type')}Type"
      end

      # @return [String]
      def file_name
        "#{name.underscore.chomp('_type')}_type"
      end
    end
  end
end
