class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        before_action :skip_session_storage

        private
        def render_error(message, status)
                render json: { error: message }, status: status
        end

        def skip_session_storage
                request.session_options[:skip] = true
        end
end
