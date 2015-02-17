class ApplicationController < ActionController::API

  # for Devise gem
  include ActionController::MimeResponds
  include ActionController::StrongParameters

  # helpers
  include ApplicationHelper::APIHelper

  # Json response
  respond_to :json

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController,::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  # application wide variables
  def content_selection_manager
    @content_selection_manager ||= ContentSelectionManager.new
  end 
  
  def comment_selection_manager
    @comment_selection_manager ||= CommentSelectionManager.new
  end 
  
  def history_manager
    @history_manager ||= HistoryManager.new
  end 

  def notifications_manager
    @notifications_manager ||= NotificationsManager.new
  end 

  def favorite_content_manager
    @favorite_content_manager ||= FavoriteContentManager.new
  end 
      
    
  private

  def render_error(status, exception)
    if(status == 404)
      logger.info "Not Found: '#{request.fullpath}'.\n#{exception.class} error was raised for path .\n#{exception.message}"
    else
      logger.info "System Error: Tried to access '#{request.fullpath}'.\n#{exception.class} error was raised for path .\n#{exception.message}"
    end

    render :json=> {}, :status=> status
  end

end
