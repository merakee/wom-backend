require 'rails_helper'

def able_to_get_content(path,user,msg=nil)
    get path, auth_params(user)
    expect_response_to_have(response,sucess=true,status=:ok,msg)
    expect(json["contents"]).not_to be_nil
end

def not_able_to_get_content(path,user,msg=nil)
    get path, auth_params(user)
    expect_response_to_have(response,sucess=false,status=:unauthorized,msg)
end

shared_examples "user with access to content" do
  it 'can get content' do
    able_to_get_content(path,user)
  end

  it 'cannot get if email is missing' do
    user.email=""
    not_able_to_get_content(path,user)
  end

  it 'cannot get if token is missing' do
    user.authentication_token=""
    not_able_to_get_content(path,user)
  end

  it 'cannot get if email is wrong' do
    user.email="user@wrong.com"
    not_able_to_get_content(path,user)
  end

  it 'cannot get if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    not_able_to_get_content(path,user)
  end

  it 'can get content list' do
    user=  create(:user)
    (1..11).to_a.each{|x| create(:content, user_id: user.id)}
    able_to_get_content(path,user)
    expect(json["contents"].count).to eq(11)
  end

  it 'can get content list' do
    user=  create(:user)
    (1..19).to_a.each{|x| create(:content, user_id: user.id)}
    able_to_get_content(path,user)
    expect(json["contents"].count).to eq(19)
  end

  it 'can post content', :focus => true do
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=true,status=:created)
    # check that the attributes are the same.
    expect(json['content']).to include('user_id','content_category_id','text','photo_token')
    expect(json['content']).not_to include('kill_count','no_response_count','spread_count','total_spread')
    expect(json['content']['user_id']).to eq(user.id)
    expect(json['content']['content_category_id']).to eq(content.content_category_id)
    expect(json['content']['text']).to eq(content.text)
    expect(json['content']['photo_token']).not_to be nil
  end

  it 'cannot post content without user email' do
    post path, user.as_json(root: true, only: [:authentication_token]).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content with empty user email' do
    user.email =""
    content = build(:content, user_id: nil)
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content without user auth token' do
    content = build(:content, user_id: nil)
    post path, user.as_json(root: true, only: [:email]).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content with empty auth token' do
    user.authentication_token =""
    content = build(:content, user_id: nil)
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post content without user info ' do
    post path, content.as_json(root: true, only: [:content_category_id, :text])
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with empty text' do
    content.text= ""
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content without text' do
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with empty content_category_id' do
    content.content_category_id= nil
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content without content_category_id' do
    content.user_id=nil
    post path, auth_params(user).merge(content.as_json(root: true, only: [:text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with short text' do
    content.text= "1"
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post content with too long text' do
    content.text= "agin and "*100
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end
  
  it 'cannot post content more than once' do
    content = build(:content, user_id: nil)
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"text" => ["User already has this content for the same category"])
  end
  
    it 'can post same content in different category' do
    content = build(:content, user_id: nil)
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    content['content_category_id'] = (content['content_category_id']+1)%4+1
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=true,status=:created)
  end
  
    it 'can post content with photo',  :focus => true do
      contentwp = {content: {content_category_id: content.content_category_id,
        text: content.text,
        photo_token: {
          file: Base64.encode64(File.new(content.photo_token.url, 'rb').read),
          filename: "image.jpg",
          content_type: "image/jpeg"}}}

            
    #post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text, :photo_token]))
      post path, auth_params(user).merge(contentwp)      
    
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

describe "API " do
  let(:path) {"/api/v0/contents"}
  let(:content){build(:content, user_id: nil)}

  describe "Content: normal " do
    let(:user) {create :user}
    it_behaves_like  "user with access to content"
  end
  describe "Content: anonymous user" do
    let(:user) {get_user_anonymous}
    #it_behaves_like  "user with access to content"
  end

end
