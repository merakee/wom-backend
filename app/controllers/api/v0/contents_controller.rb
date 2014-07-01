class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_or_auth_token!
  def index
    # show list of content for user with :id
    render :json => Content.limit(20)
  end

  def create
    # add new content
    content = User.new(content_params)
    contene.save
  end

  private

  def content_params
    params.require(:content).permit(:content_category,:text,:user_id)
  end

end
