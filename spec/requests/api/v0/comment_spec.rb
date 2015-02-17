require 'rails_helper'

def able_to_get_comment(path,user,params,msg=nil)      
    post get_path, auth_params(user).merge(params)#.as_json(root: true, only: [:content_id,:mode,:count,:offset]))
    expect_response_to_have(response,sucess=true,status=:ok,msg)
    expect(json["comments"]).not_to be_nil    
    expect(json['comments'][0]).to include("id", "user_id", "content_id", "text", "like_count", "new_like_count", "created_at", "updated_at", "did_like")
end

def not_able_to_get_comment(path,user,params,msg=nil)
    post get_path, auth_params(user).merge(params)#.as_json(root: true, only: [:content_id,:mode,:count,:offset]))
    expect_response_to_have(response,sucess=false,status=:unauthorized,msg)
end

def add_comment(count=1)
  user =  create(:user)
   (1..count).to_a.each{|x| create(:comment, content: content, user: user)}
end

shared_examples "user with access to comment" do
  it 'can get comment' do
    add_comment
    able_to_get_comment(path,user,params)
  end

  it 'cannot get comment if email is missing' do
    user.email=""
    not_able_to_get_comment(path,user,params)
  end

  it 'cannot get comment if token is missing' do
    user.authentication_token=""
    not_able_to_get_comment(path,user,params)
  end

  it 'cannot get comment if email is wrong' do
    user.email="user@wrong.com"
    not_able_to_get_comment(path,user,params)
  end

  it 'cannot get comment if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    not_able_to_get_comment(path,user,params)
  end
  
  it 'can get comment list' do
    add_comment(11)
    able_to_get_comment(path,user,params)
    expect(json["comments"].count).to eq(11)
  end

  it 'can get comment list with offset' do
    add_comment(34)
    params[:params][:offset] =  21
    able_to_get_comment(path,user,params)
    expect(json["comments"].count).to eq(13)
  end

  it 'can post comment' do
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=true,status=:created)
    # check that the attributes are the same.
    expect(json['comment']).to include("id", "user_id", "content_id", "text")
    expect(json['comment']).not_to include('did_like')
    expect(json['comment']['user_id']).to eq(user.id)
    expect(json['comment']['text']).to eq(comment.text)
    expect(json['comment']['content_id']).to eq(content.id)
  end

  it 'can post long comment (400)' do
    comment.text = Faker::Lorem.characters(400)
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=true,status=:created)
    # check that the attributes are the same.
    expect(json['comment']).to include("id", "user_id", "content_id", "text")
    expect(json['comment']).not_to include('did_like')
    expect(json['comment']['user_id']).to eq(user.id)
    expect(json['comment']['text']).to eq(comment.text)
    expect(json['comment']['content_id']).to eq(content.id)
  end
  
  it 'cannot post comment over 400 charecters' do
    comment.text = Faker::Lorem.characters(401)
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end
  
  it 'cannot post comment without user email' do
    post post_path, user.as_json(root: true, only: [:authentication_token]).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post comment with empty user email' do
    user.email =""
    comment = build(:comment, user_id: nil)
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post comment without user auth token' do
    comment = build(:comment, user_id: nil)
    post post_path, user.as_json(root: true, only: [:email]).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post comment with empty auth token' do
    user.authentication_token =""
    comment = build(:comment, user_id: nil)
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot post comment without user info ' do
    post post_path, comment.as_json(root: true, only: [:content_id, :text])
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post comment without content info ' do
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end
  
  it 'cannot post comment with empty text' do
    comment.text= ""
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post comment without text' do
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:comment_category_id]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post comment with short text' do
    comment.text= ""
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end

  it 'cannot post comment with too long text' do
    comment.text= "agin and "*100
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
  end
  
  it 'cannot post comment more than once' do
    comment = build(:comment, user_id: nil)
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    post post_path, auth_params(user).merge(comment.as_json(root: true, only: [:content_id, :text]))
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"text" => ["User already has this comment for the same content"])
  end

end

describe "API " do  
  let(:get_path) {"/api/v0/comments/getlist"}
  let(:post_path){"/api/v0/comments/create"}

  describe "Comment: normal " do  
    let(:user) {create :user}
    let(:content) {create :content}
    let(:comment){build(:comment, content: content, user: nil)}
    let(:params) {{params: {content_id: content.id, count: 100, offset:0}}}
  
    
    it_behaves_like  "user with access to comment"
  end
  
  describe "Comment: anonymous user" do
    #let(:user) {get_user_anonymous}
    #it_behaves_like  "user with access to comment"
  end

end
