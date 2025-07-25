# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins "example.com"
#
#     resource "*",
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins = if Rails.env.development?
                %w[http://localhost:4200 http://127.0.0.1:4200]
    else
                [ "https://kadince-todo-frontend.onrender.com" ]
    end
    origins origins

    resource "*",
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: [ :get, :post, :options, :delete, :put, :patch ],
             credentials: true
  end
end
