class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def index
    # show list of content for user with :id
    offset = [rand(Content.count)-APIConstants::CONTENT::RESPONSE_SIZE, 0].max
    contents = Content.limit(APIConstants::CONTENT::RESPONSE_SIZE).offset(offset)
    render :json => {:success => true,:contents => (contents.as_json(only: [:id, :user_id, :content_category_id, :text, :photo_token, :total_spread, :spread_count, :kill_count, :created_at]))}, :status=> :ok
  end

  def create
    # add new content
    content = Content.new(content_params)
    content.user_id = @current_user.id
    if content.save
      render :json => {:success => true,:content => (content.as_json(only: [:id, :user_id, :content_category_id, :text, :photo_token]))}, :status=> :created
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (content.errors.as_json)}, :status=> :unprocessable_entity
    end

  ensure
    clean_tempfile
  end

  private

  def content_params
    process_photo_token_params(params[:content][:photo_token])
    params.require(:content).permit(:content_category_id,:text, :photo_token)
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
