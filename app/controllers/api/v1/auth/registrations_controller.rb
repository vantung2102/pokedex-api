module API
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        private

        def sign_up_params
          params.require(:user).permit(
            :email,
            :first_name,
            :last_name,
            :password,
            :password_confirmation
          )
        end

        def respond_with(resource, _opts = {})
          if resource.errors.any?
            render_resource_errors(resource.errors)
          else
            render_response_for_action(resource)
          end
        end

        def render_response_for_action(resource)
          case action_name
          when 'create', 'update'
            status = resource.previous_changes[:id].present? ? :created : :ok
            render_resource(resource, status: status)
          when 'destroy'
            head :no_content
          end
        end
      end
    end
  end
end
