require 'rails_helper'
def able_to_get_contentlist(path,user,msg=nil)
    post path, auth_params(user)
    expect_response_to_have(response,sucess=true,status=:ok,msg)
    expect(json["contents"]).not_to be_nil
    expect(json['contents'][0]).to include("id", "user_id", "content_category_id", "text", "photo_token", "total_spread", "spread_count", "kill_count", "comment_count", "new_comment_count", "created_at", "updated_at")
end

def not_able_to_get_contentlist(path,user,msg=nil)
    post path, auth_params(user)
    expect_response_to_have(response,sucess=false,status=:unauthorized,msg)
end

def able_to_get_content_recentlist(path,user,count=20,offset=0,msg=nil)
    post path, auth_params(user).merge({params:{count: count, offset: offset}})
    expect_response_to_have(response,sucess=true,status=:ok,msg)
    expect(json["contents"]).not_to be_nil
    puts json["contents"].count
    expect(json["contents"].count).to be <= count 
    expect(json['contents'][0]).to include("id", "user_id", "content_category_id", "text", "photo_token", "total_spread", "spread_count", "kill_count", "comment_count", "new_comment_count", "created_at", "updated_at")
end

def not_able_to_get_content_recentlist(path,user,msg=nil)
    post path, auth_params(user)
    expect_response_to_have(response,sucess=false,status=:unauthorized,msg)
end

def able_to_get_content(path,user,content_id,msg=nil)
    post path, auth_params(user).merge({params:{content_id: content_id}})
    expect_response_to_have(response,sucess=true,status=:ok,msg)
    expect(json["content"]).not_to be_nil     
    expect(json["content"]).to include("id", "user_id", "content_category_id", "text", "photo_token", "total_spread", "spread_count", "kill_count", "comment_count", "new_comment_count", "created_at", "updated_at")
    expect(json["content"]["id"]).to eq(content_id)
end

def not_able_to_get_content(path,user,content_id,msg=nil)
    post path, auth_params(user).merge({params:{content_id: content_id}})
    expect_response_to_have(response,sucess=false,status=:unauthorized,msg)
end

def add_content(count=1)
  user =  create(:user)
   (1..count).to_a.each{|x| create(:content, user_id: user.id)}
end

shared_examples "get content" do
  it 'can get content' do
    content = create(:content,user: user)
    able_to_get_content(getcontent_path,user,content.id)
  end

  it 'cannot get content if email is missing' do
    user.email=""
    not_able_to_get_content(getcontent_path,user,content.id)
  end

  it 'cannot get content if token is missing' do
    user.authentication_token=""
    not_able_to_get_content(getcontent_path,user,content.id)
  end

  it 'cannot get content if email is wrong' do
    user.email="user@wrong.com"
    not_able_to_get_content(getcontent_path,user,content.id)
  end

  it 'cannot get content if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    not_able_to_get_content(getcontent_path,user,content.id)
  end
end

shared_examples "get content list" do
  it 'can get content' do
    add_content
    able_to_get_contentlist(getlist_path,user)
  end

  it 'cannot get content if email is missing' do
    user.email=""
    not_able_to_get_contentlist(getlist_path,user)
  end

  it 'cannot get content if token is missing' do
    user.authentication_token=""
    not_able_to_get_contentlist(getlist_path,user)
  end

  it 'cannot get content if email is wrong' do
    user.email="user@wrong.com"
    not_able_to_get_contentlist(getlist_path,user)
  end

  it 'cannot get content if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    not_able_to_get_contentlist(getlist_path,user)
  end
  
  it 'can get content list' do
    add_content(11)
    able_to_get_contentlist(getlist_path,user)
    expect(json["contents"].count).to eq(11)
  end

end


shared_examples "get content recent list" do
  it 'can get content' do
    add_content(21)
    able_to_get_content_recentlist(getrecentlist_path,user,19)
    expect(json["contents"].count).to eq(19)
  end

  it 'cannot get content if email is missing' do
    user.email=""
    not_able_to_get_content_recentlist(getrecentlist_path,user)
  end

  it 'cannot get content if token is missing' do
    user.authentication_token=""
    not_able_to_get_content_recentlist(getrecentlist_path,user)
  end

  it 'cannot get content if email is wrong' do
    user.email="user@wrong.com"
    not_able_to_get_content_recentlist(getrecentlist_path,user)
  end

  it 'cannot get content if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    not_able_to_get_content_recentlist(getrecentlist_path,user)
  end
  
  it 'can get content list' do
    add_content(5)
    able_to_get_content_recentlist(getrecentlist_path,user)
    expect(json["contents"].count).to eq(5)
  end

end

shared_examples "post content" do
  it 'can post content' do
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=true,status=:created)
    # check that the attributes are the same.
    expect(json['content']).to include("id", "user_id", "content_category_id", "text", "photo_token", "total_spread", "spread_count", "kill_count", "comment_count", "new_comment_count", "created_at", "updated_at")
    expect(json['content']['user_id']).to eq(user.id)
    expect(json['content']['content_category_id']).to eq(content.content_category_id)
    expect(json['content']['text']).to eq(content.text)
    expect(json['content']['photo_token']).not_to be nil
  end

  it 'cannot post content without user email' do
    post create_path, user.as_json(root: true, only: [:authentication_token]).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content with empty user email' do
    user.email =""
    content = build(:content, user_id: nil)
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content without user auth token' do
    content = build(:content, user_id: nil)
    post create_path, user.as_json(root: true, only: [:email]).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content with empty auth token' do
    user.authentication_token =""
    content = build(:content, user_id: nil)
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content without user info ' do
    post create_path, content.as_json(root: true, only: [:content_category_id, :text])
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with empty text' do
    content.text= ""
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content without text' do
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with empty content_category_id' do
    content.content_category_id= nil
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content without content_category_id' do
    content.user_id=nil
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with short text' do
    content.text= ""
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with too long text' do
    content.text= "agin and "*100
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end
  
  it 'cannot post content more than once' do
    content = build(:content, user_id: nil)
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"text" => ["User already has this content for the same category"])
  end
  
    it 'can post same content in different category' do
    content = build(:content, user_id: nil)
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    content['content_category_id'] = (content['content_category_id']+1)%4+1
    post create_path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=true,status=:created)
  end
  
    xit 'can post content with photo' do
      content = build(:content,:with_photo, user_id: nil)

      contentwp = {content: 
          {content_category_id: content.content_category_id,
          text: content.text,
          photo_token: {
          file: Base64.encode64(File.new(content.photo_token.url, 'rb').read),
          filename: "image.jpg",
          content_type: "image/jpeg"}
          }
        }
    #post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text, :photo_token]))
    post create_path, auth_params(user).merge(contentwp)      
    # expect_response_to_have(response,sucess=true,status=:created)
    # check that the attributes are the same.
    expect(json['content']).to include('user_id','content_category_id','text','photo_token')
    expect(json['content']).not_to include('kill_count','no_response_count','spread_count','total_spread')
    expect(json['content']['user_id']).to eq(user.id)
    expect(json['content']['content_category_id']).to eq(content.content_category_id)
    expect(json['content']['text']).to eq(content.text)
    expect(json['content']['photo_token']).not_to be nil 
    expect(json['content']['photo_token']['url']).not_to be nil 
    expect(json['content']['photo_token']['url']).to include("wombackend-dev-freelogue")
    
    expect(json['content']['photo_token']['thumb']).not_to be_nil
    expect(json['content']['photo_token']['thumb']['url']).not_to be nil 
    expect(json['content']['photo_token']['thumb']['url']).to include("wombackend-dev-freelogue")
  end
end


shared_examples "delete content" do
   ENV['ADMIN_PASS']="admin_pass"
      
  it 'can delete content' do
    content = create(:content, user_id: user.id)
    params= {params: {content_id: content.id, admin_pass:"admin_pass"}}
    post delete_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=true,status=:ok)
    # check that the attributes are the same.
    expect(json['content']).to include("id", "user_id", "content_category_id", "text", "photo_token", "total_spread", "spread_count", "kill_count", "comment_count", "new_comment_count", "created_at", "updated_at")
    expect(json['content']['user_id']).to eq(user.id)
    expect(json['content']['content_category_id']).to eq(content.content_category_id)
    expect(json['content']['text']).to eq(content.text)
  end

  it 'cannot delete content without admin pass' do
    content = create(:content, user_id: user.id)
    params= {params: {content_id: content.id}}
    post delete_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end
  
  it 'cannot delete content with empty admin pass' do
    content = create(:content, user_id: user.id)
    params= {params: {content_id: content.id, admin_pass:""}}
    post delete_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot delete content with nil admin pass' do
    content = create(:content, user_id: user.id)
    params= {params: {content_id: content.id, admin_pass:nil}}
    post delete_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot delete content with nil ENV admin pass' do
    ENV['ADMIN_PASS']=nil
    content = create(:content, user_id: user.id)
    params= {params: {content_id: content.id, admin_pass:nil}}
    post delete_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end
  
  it 'cannot delete content with empty ENV admin pass' do
    ENV['ADMIN_PASS']=""
    content = create(:content, user_id: user.id)
    params= {params: {content_id: content.id, admin_pass:nil}}
    post delete_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end
  
end

describe "API " do  
  let(:getlist_path) {"/api/v0/contents/getlist"}
  let(:getcontent_path) {"/api/v0/contents/getcontent"}
  let(:create_path){"/api/v0/contents/create"}
  let(:getrecentlist_path) {"/api/v0/contents/getrecent"}
  let(:delete_path){"/api/v0/contents/delete"}
    
  describe "Content: normal " do  
    let(:user) {create :user}
    let(:content){build(:content, user: user)}
    it_behaves_like  "get content"
    it_behaves_like  "get content list"
    it_behaves_like  "get content recent list"
    it_behaves_like  "post content"
    it_behaves_like  "delete content"
  end
  
  describe "Content: anonymous user" do
    #let(:user) {get_user_anonymous}
    #it_behaves_like  "user with access to content"
  end

end
