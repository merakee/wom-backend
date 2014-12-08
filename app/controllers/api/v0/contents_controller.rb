class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
   def index
    # get content for user: content selection manager
    contents = content_selection_manager.get_contents_for_user(@current_user.id)
    #offset = [rand(Content.count)-APIConstants::CONTENT::RESPONSE_SIZE, 0].max
    #contents = Content.limit(APIConstants::CONTENT::RESPONSE_SIZE).offset(offset)
    #render :json => {:success => true,:contents => (contents.as_json(only: select_keys_for_content))}, :status=> :ok
    render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
  end

  def get_content
    # get single content 
    content = Content.where(id:get_content_params[:content_id])[0]
    if content   
      #render :json => {:success => true, :content => content.as_json(only: select_keys_for_content)}, :status=> :ok
      render :json => {:success => true, :content => content.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Invalid content id"}, :status=> :unprocessable_entity
    end
  end
  
  def create
    # add new content
    content = Content.new(content_params)
    content.user_id = @current_user.id
    if content.save
      #render :json => {:success => true,:content => (content.as_json(only: select_keys_for_content))}, :status=> :created
      render :json => {:success => true,:content => content.as_json}, :status=> :created
    else
      warden.custom_failure!
      render :json => {:success => false, :message => content.errors.as_json}, :status=> :unprocessable_entity
    end

    ensure
     clean_tempfile
  end


   def get_recent
    # get contents recent: content selection manager
    contents = content_selection_manager.get_contents_recent(get_recent_params)
    render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
  end
  
  def destroy
    # check if admin 
    render :json => {:success => false, :message=> "Unauthorized user"}, :status => :unauthorized and return unless is_admin
    
    # delete content
    content = Content.where(id:delete_content_params[:content_id])[0]
    if content.delete
      #render :json => {:success => true,:content => (content.as_json(only: select_keys_for_content))}, :status=> :created
      render :json => {:success => true,:content => content.as_json}, :status=> :ok
    else
      warden.custom_failure!
      render :json => {:success => false, :message => content.errors.as_json}, :status=> :unprocessable_entity
    end
  end
  
  
  private

  def content_params
    process_photo_token_params(params[:content][:photo_token]) unless params[:content].nil? 
    params.require(:content).permit(:content_category_id,:text, :photo_token)
  end

  def get_content_params
    params.require(:params).permit(:content_id) 
  end
  
  def get_recent_params
    params_ = params.require(:params).permit(:count,:offset)
    convert_params_to_int(params_,[:count,:offset])
    params_
  end
    
  def delete_content_params
      params.require(:params).permit(:content_id) 
  end
    
  def is_admin
    admin_pass = params.require(:params).permit(:admin_pass)[:admin_pass]
    (!admin_pass.blank?) && admin_pass.eql?(ENV['ADMIN_PASS']) 
  end
  
  def process_photo_token_params(photo_token)
    if photo_token && photo_token[:file]
      @tempfile = Tempfile.new('content_photo')
      @tempfile.binmode
      @tempfile.write Base64.decode64(photo_token[:file])
      @tempfile.rewind

      params[:content][:photo_token] = ActionDispatch::Http::UploadedFile.new(
      :tempfile => @tempfile,
      :content_type => photo_token[:content_type],
      :filename => photo_token[:filename])
    end

  end

  def clean_tempfile
    # clean up tempfile user for params processing
    # close! closes and deletes (unlicks) the file
    @tempfile.close!  if @tempfile
  end

end
