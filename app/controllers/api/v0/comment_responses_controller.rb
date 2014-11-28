class API::V0::CommentResponsesController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
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