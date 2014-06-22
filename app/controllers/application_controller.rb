class ApplicationController < ActionController::API

  # for Devise gem
  include ActionController::MimeResponds
  include ActionController::StrongParameters

  # Json response
  respond_to :json

end
