class API::V0::HistoryController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def contents
    # get contents for user: History  manager
    contents = history_manager.get_contents(history_params.merge({user_id:@current_user.id}))
    if(contents)
      render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  def comments
    # get contents for user: History  manager
    comments = history_manager.get_comments(history_params.merge({user_id:@current_user.id}))
    if(comments)
      render :json => {:success => true,:comments => comments.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  private

  def history_params
    params_ = params.require(:params).permit(:count,:offset)
    convert_params_to_int(params_,[:count,:offset])
    params_
  end

end