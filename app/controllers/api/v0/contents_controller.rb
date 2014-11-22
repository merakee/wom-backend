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

  private

  def content_params
    params_fil = params.require(:content).permit(:content_category_id,:text, :photo_token)
    process_photo_token_params(params[:content][:photo_token])
    params_fil     
  end

  def get_content_params
    params.require(:params).permit(:content_id) 
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
