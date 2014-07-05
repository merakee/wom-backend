class ApplicationController < ActionController::API

  # for Devise gem
  include ActionController::MimeResponds
  include ActionController::StrongParameters

  # helpers 
  include ApplicationHelper::APIHelper
  
  # Json response
  respond_to :json



end
