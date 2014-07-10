class API::V0::UserResponsesController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  
  
  api :POST,  '/user_responses', "Post Response"
  #api_versions
  api_version "0.0"
  formats ['json']
  param_group :user_auth, API::V0::APIController
  param :response, Hash, :desc => "User Reponse" , :required => true do
    param :content_id, Integer, :desc => "Content Id", :required => true
    param :response,:bool, :desc => "Response Y/N", :allow_nil => true,:required => true, :meta => "Spread => true, Kill => false, No Response => Nil"
  end
  description "Post content from authorized user"
  error :code => 401, :desc => "Unauthorized"
  error :code => 422, :desc => "Unprocessable Entity"
  example "{'success':true, 'response':{'id':2758, 'user_id':3465495, 'content_id':65405423, 'response':true}}"
  
  
  def create
    # add new response to db
    user_response = UserResponse.new(response_params)
    user_response.user_id = @current_user.id
    if user_response.save
      render :json => {:success => true, :response => (user_response.as_json(only: [id, :user_id, :content_id, :response]))}, :status=> :created #201
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
