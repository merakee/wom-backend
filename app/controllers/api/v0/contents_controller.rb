class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def index
    # show list of content for user with :id
    offset = [rand(Content.count)-APIConstants::CONTENT::RESPONSE_SIZE, 0].max
    contents = Content.limit(APIConstants::CONTENT::RESPONSE_SIZE).offset(offset)
    render :json => {:success => true,:contents => (contents.as_json(only: [:id, :user_id, :content_category_id, :text, :photo_token, :total_spread, :spread_count, :kill_count, :created_at]))}, :status=> :ok
  end

  def create
    
    # add new content
    #check if file is within picture_path
    puts content_params
    @content = Content.new(content_params)
    puts "....................."
    puts @content.photo_token.inspect
    puts "....................."
    #@content[:photo_token] = content_params[:photo_token]  
    @content.user_id = @current_user.id
    if @content.save
      puts @content.to_json
      puts @content.photo_token
      render :json => {:success => true,:content => (@content.as_json(only: [:id, :user_id, :content_category_id, :text, :photo_token]))}, :status=> :created
    return
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (@content.errors.as_json)}, :status=> :unprocessable_entity
    end
  end

  private

  def content_params
    params.require(:content).permit!#(:content_category_id,:text, :photo_token)
    #json_params = ActionController::Parameters.new( JSON.parse(request.body.read) )
    #json_params.require(:content).permit(:content_category_id,:text,:photo_token)
  end

end
