Apipie.configure do |config|
  config.app_name = "WoM BackEnd API"
  config.copyright = "&copy; 2014 FreeLogue Inc."
  config.api_base_url = "/api"
  config.doc_base_url = "/apipie"
  config.default_version = "0.0"
  config.validate = false
  #config.markup = Apipie::Markup::Markdown.new
  config.reload_controllers = Rails.env.development?
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "**","*.rb")
  #config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
  config.api_routes = Rails.application.routes
  config.app_info = "WoM API: Develpoment : Description TBA"
  config.authenticate = Proc.new do
     authenticate_or_request_with_http_basic do |username, password|
       username == "freelogue" && password == "freelogue2014"
    end
  end
  config.use_cache = Rails.env.production?
  #config.namespaced_resources = true 
end
