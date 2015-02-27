class API::V0::CommentResponsesController < API::V0::APIController
  before_filter  :authenticate_user_from_token!

  # Save user response for current user given Comment Response with Comment id and response
  # @action POST
  # @url /api/v0/comments/response
  # @discussion Permitted action for all users. User can only like a content and may like only once. 
  # @required body
  # @response Comment Response Object
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user":{ "user_type_id":2, "email":"test_user1@test.com", "authentication_token":"oTL6Koq5VESxbr_6K9rJ"}, "comment_response":{ "comment_id":13, "response":true}}
  # @example_response
  #   { "success":true,"comment_response":{ "id":126,"user_id":82,"comment_id":13,"response":true,"created_at":"2015-03-02T20:30:43.058Z"}}
  def create
    # add new response to db
    cresponse = CommentResponse.new(response_params)
    cresponse.user_id = @current_user.id
    if cresponse.save
      #render :json => {:success => true, :response => cresponse.as_json(only: [:id, :user_id, :comment_id, :response])}, :status=> :created #201
      render :json => {:success => true, :comment_response => cresponse.as_json}, :status=> :created #201
    return
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (cresponse.errors.as_json)}, :status=> :unprocessable_entity
    end
  end
  private

  def response_params
    params.require(:comment_response).permit(:comment_id,:response)
  end

end