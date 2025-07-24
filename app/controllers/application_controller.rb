class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken

        private
        def render_error(message, status)
                render json: { error: message }, status: status
        end
end
