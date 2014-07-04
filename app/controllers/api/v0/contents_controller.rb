class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def index
    # show list of content for user with :id
    render :json => Content.limit(20)
  end

  def create
    # add new content
    content = Content.new(content_params)
    content.user_id = @current_user.id
    if content.save
      render :json => content.as_json(root: true, only: [:id, :user_id, :content_category_id, :text, :photo_token]), :status=>201
    return
    else
      warden.custom_failure!
      render :json => content.errors, :status=> :unprocessable_entity
    end
  end

  private

  def content_params
    params.require(:content).permit(:content_category_id,:text)
  end

end
