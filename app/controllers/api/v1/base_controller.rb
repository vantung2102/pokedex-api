module API
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      private

      def policy_scope(scope, policy_scope_class: nil, replace_parent_scope: false)
        super(replace_parent_scope ? scope : [:api, scope], policy_scope_class:)
      end

      def authorize(record, query = nil, policy_class: nil, replace_parent_scope: false)
        super(replace_parent_scope ? record : [:api, record], query, policy_class:)
      end
    end
  end
end
