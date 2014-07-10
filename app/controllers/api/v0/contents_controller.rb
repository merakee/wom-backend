class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  
  api :GET,  '/contents', "Show user profile info"
  #api_versions
  api_version "0.0"
  formats ['json']
  param_group :user_auth, API::V0::APIController
  #param
  description "Retunrs contents for authorized user"
  error :code => 401, :desc => "Unauthorized"
  example "{'success':true,'contents':{'id':3627, 'content_category_id':3, 'text':This is a rumor, 'photo_token':df343hfdfkt}}"
  meta "The number of contents sent each request is set in APIConstants::CONTENT::RESPONSE_SIZE (#{APIConstants::CONTENT::RESPONSE_SIZE})"
  
  def index
    # show list of content for user with :id
    contents = Content.limit(APIConstants::CONTENT::RESPONSE_SIZE)
    render :json => {:success => true,:contents => (contents.as_json(only: [:id, :content_category_id, :text, :photo_token]))}, :status=> :ok
  end

  api :POST,  '/contents', "Post Content"
  #api_versions
  api_version "0.0"
  formats ['json']
  param_group :user_auth, API::V0::APIController
  param :content, Hash, :desc => "Content" , :required => true do
      param :content_category_id, Integer, :desc => "Content Category", :required => true, :meta => "Must be between 1 to 4"
      param :text, String, :desc => "Password", :required => true, :meta => "Length must be between APIConstants::CONTENT::MIN_TEXT_LENGTH (#{APIConstants::CONTENT::MIN_TEXT_LENGTH}) and APIConstants::CONTENT::MAX_TEXT_LENGTH(#{APIConstants::CONTENT::MAX_TEXT_LENGTH})"
    end
  #param
  description "Post content from authorized user"
  error :code => 401, :desc => "Unauthorized"
  error :code => 422, :desc => "Unprocessable Entity"
  example "{'success':true,'content':{'user_id':7627, 'content_category_id':3, 'text':This is a rumor, 'photo_token':df343hfdfkt}}"
  
  def create
    # add new content
    content = Content.new(content_params)
    content.user_id = @current_user.id
    if content.save
      render :json => {:success => true,:content => (content.as_json(only: [:user_id, :content_category_id, :text, :photo_token]))}, :status=> :created
    return
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (content.errors.as_json)}, :status=> :unprocessable_entity
    end
  end

  private

  def content_params
    params.require(:content).permit(:content_category_id,:text)
  end

end
