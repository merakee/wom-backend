class API::V0::UserResponsesController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def create
    # add new response to db
    uresponse = UserResponse.new(response_params)
    uresponse.user_id = @current_user.id
    if uresponse.save
      render :json => uresponse.as_json(root: true, only: [:id, :user_id, :content_id, :response]), :status=> :created #201
    return
    else
      warden.custom_failure!
      render :json => uresponse.errors, :status=> :unprocessable_entity
    end
  end

  private

  def response_params
    params.require(:user_response).permit(:content_id,:response)  
  end

end
