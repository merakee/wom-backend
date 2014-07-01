class API::V0::ResponsesController < API::V0::APIController
  before_filter  :authenticate_user_or_auth_token!
  def create
    # add new response to db
    response = User.new(response_params)
    response.save
  end

  private

  def response_params
    params.require(:response).permit(:content_id,:user_id,:response)
  end

end
