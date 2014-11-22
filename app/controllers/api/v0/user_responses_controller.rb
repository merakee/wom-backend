class API::V0::UserResponsesController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def create
    # add new response to db
    uresponse = UserResponse.new(response_params)
    uresponse.user_id = @current_user.id
    if uresponse.save
      #render :json => {:success => true, :response => uresponse.as_json(only: [:id, :user_id, :content_id, :response])}, :status=> :created #201
      render :json => {:success => true, :response => uresponse.as_json}, :status=> :created #201
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (uresponse.errors.as_json)}, :status=> :unprocessable_entity
    end
  end

  private

  def response_params
    params.require(:user_response).permit(:content_id,:response)  
  end

end
