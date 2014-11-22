class API::V0::CommentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def index
    # get comment for user: comment selection manager
    # returns either an array of hash or nil
    # each has contains these keys: [:id, :user_id, :content_id, :text, :like_count, :created_at, :did_like]
    comments_json = comment_selection_manager.get_comments_for_content_and_user(comment_params_for_list.merge({user_id:@current_user.id}))
    if(comments_json)
      render :json => {:success => true,:comments => comments_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  def create
    # add new comment
    comment = Comment.new(comment_params_for_create)
    comment.user_id = @current_user.id
    if comment.save
      #render :json => {:success => true,:comment => (comment.as_json(only: select_keys_for_comment))}, :status=> :created
      render :json => {:success => true,:comment => comment.as_json}, :status=> :created
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (comment.errors.as_json)}, :status=> :unprocessable_entity
    end
  end

  private

  def comment_params_for_create
    params.require(:comment).permit(:content_id,:text)
  end

  def comment_params_for_list
    params_ = params.require(:params).permit(:content_id,:mode,:count,:offset)
    convert_params_to_int(params_,[:content_id,:count,:offset])
    params_
  end

end