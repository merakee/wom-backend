class API::V0::ContentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  
  # Get content list for user 
  # @action POST
  # @url /api/v0/contents/getlist
  # @discussion Permitted action for all users.
  # @required body
  # @response Array containing content objects 
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}}
  # @example_response
  #   { "success":true,
  #    "contents":[{ "id":12,"user_id":34,"content_category_id":3,"text":"Quam possimus velit.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:08.201Z","updated_at":"2015-02-13T21:40:08.201Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":2,"flag_count":0,"new_comment_count":2},
  #                { "id":17,"user_id":44,"content_category_id":4,"text":"Consectetur et sint quos et.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:09.189Z","updated_at":"2015-02-13T21:40:09.189Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":18,"user_id":46,"content_category_id":3,"text":"Reprehenderit soluta et ratione blanditiis dolor.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:09.352Z","updated_at":"2015-02-13T21:40:09.352Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":9,"user_id":28,"content_category_id":1,"text":"Ut porro mollitia ad omnis officiis.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":2,"spread_count":1,"kill_count":1,"created_at":"2015-02-13T21:40:07.563Z","updated_at":"2015-02-13T21:40:07.563Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":0,"flag_count":0,"new_comment_count":0},
  #                { "id":26,"user_id":68,"content_category_id":4,"text":"Provident ut officiis.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:11.152Z","updated_at":"2015-02-13T21:40:11.152Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":10,"user_id":30,"content_category_id":3,"text":"Aut ut qui expedita velit sapiente.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":2,"spread_count":1,"kill_count":1,"created_at":"2015-02-13T21:40:07.732Z","updated_at":"2015-02-13T21:40:07.732Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":0,"flag_count":0,"new_comment_count":0},
  #                { "id":19,"user_id":48,"content_category_id":2,"text":"Cumque sed voluptas illo eos consequatur consectetur.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:09.514Z","updated_at":"2015-02-13T21:40:09.514Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":20,"user_id":50,"content_category_id":2,"text":"Et minus aut.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:09.706Z","updated_at":"2015-02-13T21:40:09.706Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":14,"user_id":38,"content_category_id":1,"text":"In sit at dolorem.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:08.650Z","updated_at":"2015-02-13T21:40:08.650Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":15,"user_id":40,"content_category_id":4,"text":"Ea aut quo aperiam error.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:08.845Z","updated_at":"2015-02-13T21:40:08.845Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":21,"user_id":53,"content_category_id":3,"text":"Voluptatibus voluptate eum occaecati.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:09.949Z","updated_at":"2015-02-13T21:40:09.949Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":27,"user_id":71,"content_category_id":3,"text":"Ea voluptates unde.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:11.393Z","updated_at":"2015-02-13T21:40:11.393Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":22,"user_id":56,"content_category_id":4,"text":"Aut nemo ipsa error mollitia.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:10.195Z","updated_at":"2015-02-13T21:40:10.195Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":23,"user_id":59,"content_category_id":1,"text":"Perferendis sed est ipsa enim voluptas.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:10.436Z","updated_at":"2015-02-13T21:40:10.436Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":24,"user_id":62,"content_category_id":2,"text":"Aspernatur quia labore sit qui sunt quasi cumque.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:10.675Z","updated_at":"2015-02-13T21:40:10.675Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":28,"user_id":74,"content_category_id":1,"text":"Corporis nihil dolorem delectus voluptas eveniet temporibus fugiat.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:11.712Z","updated_at":"2015-02-13T21:40:11.712Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":29,"user_id":77,"content_category_id":2,"text":"Laboriosam est sunt ad autem placeat occaecati blanditiis.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:12.047Z","updated_at":"2015-02-13T21:40:12.047Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":30,"user_id":80,"content_category_id":1,"text":"Qui voluptas nesciunt.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:12.298Z","updated_at":"2015-02-13T21:40:12.298Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                { "id":11,"user_id":32,"content_category_id":3,"text":"Itaque ut ea temporibus voluptate iure magnam.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:07.926Z","updated_at":"2015-02-13T21:40:07.926Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":3,"flag_count":0,"new_comment_count":3},
  #                { "id":25,"user_id":65,"content_category_id":2,"text":"Illum omnis accusamus dolores vitae quia culpa dolore.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":2,"spread_count":1,"kill_count":1,"created_at":"2015-02-13T21:40:10.913Z","updated_at":"2015-02-13T21:40:10.913Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1}]}
  
   def index
    # get content for user: content selection manager
    contents = content_selection_manager.get_contents_for_user(@current_user.id)
    #offset = [rand(Content.count)-APIConstants::CONTENT::RESPONSE_SIZE, 0].max
    #contents = Content.limit(APIConstants::CONTENT::RESPONSE_SIZE).offset(offset)
    #render :json => {:success => true,:contents => (contents.as_json(only: select_keys_for_content))}, :status=> :ok
    render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
  end

  # Get single content for user given content id as params 
  # @action POST
  # @url /api/v0/contents/getcontent
  # @discussion Permitted action for all users.
  # @required body
  # @response A Content object 
  # @response :unauthorized
  # @response :unprocessable_entity
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "content_id": 13}}
  # @example_response
  #    { "success":true,
  #      "content":{ "id":13,"user_id":36,"content_category_id":2,"text":"Eaque perferendis eos consequuntur.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":2,"spread_count":2,"kill_count":0,"created_at":"2015-02-13T21:40:08.381Z","updated_at":"2015-02-13T21:40:08.381Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1}}
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
  
  # Save content for user given content params
  # @action POST
  # @url /api/v0/contents/create
  # @discussion Permitted action for only signed in user (non anonymous). 
  # @required body
  # @response A Content object 
  # @response :unauthorized
  # @response :unprocessable_entity
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "content": { "content_category_id": 1, "text": "This is a text only content"}}
  # @example_response 
  #    { "success":true,
  #      "content":{ "id":150,"user_id":82,"content_category_id":1,"text":"This is a text only content","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":0,"spread_count":0,"kill_count":0,"created_at":"2015-03-02T21:07:01.116Z","updated_at":"2015-03-02T21:07:01.116Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":0,"flag_count":0,"new_comment_count":0}}  
  # @example_request 
  #    { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "content": { "content_category_id": 1, "text": "This is a content with image", "photo_token": { "file": " image file converted to string with base64 code", "filename": "file.jpg", "content_type": "image/jpeg"}}}
  # @example_response 
  #    { "success":true,
  #      "content":{ "id":151,"user_id":82,"content_category_id":1,"text":"This is a content with image","photo_token":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/content/photo_token/151/file.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=T5kT8UbneEL4jvog43Hk5Za8h08%3D\u0026Expires=1425331365","thumb":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/content/photo_token/151/thumb_file.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=KBwH7teWZ8dsQSsA738xro7W/ds%3D\u0026Expires=1425331365"}},"total_spread":0,"spread_count":0,"kill_count":0,"created_at":"2015-03-02T21:12:45.272Z","updated_at":"2015-03-02T21:12:45.272Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":0,"flag_count":0,"new_comment_count":0}}
 
  def create
    return if invalid_action_for_anonymous_user?(@current_user) 
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
    return if invalid_action_for_anonymous_user?(@current_user) 
    # get contents recent: content selection manager
    contents = content_selection_manager.get_contents_recent(get_recent_params)
    render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
  end
  
  def destroy
    #return if invalid_action_for_anonymous_user?(@current_user) 
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
