class API::V0::ContentFlagController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
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
