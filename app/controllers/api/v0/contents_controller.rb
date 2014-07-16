class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def index
    # show list of content for user with :id
    contents = Content.limit(APIConstants::CONTENT::RESPONSE_SIZE)
    render :json => {:success => true,:contents => (contents.as_json(only: [:id, :user_id, :content_category_id, :text, :photo_token, :total_spread, :spread_count, :kill_count, :created_at]))}, :status=> :ok
  end

  def create
    # add new content
    content = Content.new(content_params)
    content.user_id = @current_user.id
    if content.save
      render :json => {:success => true,:content => (content.as_json(only: [:id, :user_id, :content_category_id, :text, :photo_token]))}, :status=> :created
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
