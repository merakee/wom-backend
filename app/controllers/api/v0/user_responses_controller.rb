class API::V0::UserResponsesController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  
  # Save user response for current user given Content Response with content id and response
  # @action POST
  # @url /api/v0/contents/response
  # @discussion Permitted action for all users. User may respond only once per content. 
  # @required body
  # @response Content Response Object
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user":{ "user_type_id":2, "email":"test_user1@test.com", "authentication_token":"oTL6Koq5VESxbr_6K9rJ"}, "user_response":{ "content_id":13, "response":1}}
  # @example_response
  #   { "success":true,"content_response":{ "id":176,"user_id":82,"content_id":13,"response":true,"created_at":"2015-03-02T20:25:16.778Z","updated_at":"2015-03-02T20:25:16.778Z"}}
  
  def create
    # add new response to db
    cresponse = UserResponse.new(response_params)
    cresponse.user_id = @current_user.id
    if cresponse.save
      #render :json => {:success => true, :response => uresponse.as_json(only: [:id, :user_id, :content_id, :response])}, :status=> :created #201
      render :json => {:success => true, :content_response => cresponse.as_json}, :status=> :created #201
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (cresponse.errors.as_json)}, :status=> :unprocessable_entity
    end
  end

  private

  def response_params
    params.require(:user_response).permit(:content_id,:response)  
  end

end
