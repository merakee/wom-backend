class API::V0::ContentFlagController < API::V0::APIController
  before_filter  :permit_only_signedin_user!
  before_filter  :authenticate_user_from_token!
  
  # Flag a content for the current user given content id as params 
  # @action POST
  # @url /api/v0/contents/flag
  # @discussion Permitted action for only signed in user (non anonymous). User may flag a content only once. 
  # @required body
  # @response Content Flag Object
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "content_id": 34}}
  # @example_response
  #   { "success":true,"content_flag":{ "id":4,"user_id":82,"content_id":34,"created_at":"2015-03-02T21:21:48.796Z"}}
  
  def create
    # add new flag
    cflag = ContentFlag.new(response_params)
    cflag.user_id = @current_user.id
    if cflag.save
      #render :json => {:success => true, :content_flag => cflag.as_json(only: [:id, :user_id, :content_id])}, :status=> :created #201
      render :json => {:success => true, :content_flag => cflag.as_json}, :status=> :created #201
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (cflag.errors.as_json)}, :status=> :unprocessable_entity
    end
  end

  private

  def response_params
    params.require(:params).permit(:content_id)  
  end
end
