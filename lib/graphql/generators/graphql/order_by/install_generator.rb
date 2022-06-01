# frozen_string_literal: true

module Graphql
  module OrderBy
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_install
        copy_file('base_order_by_enum.rb', 'app/graphql/types/base_order_by_enum.rb')
      end
    end
  end
end
