require 'rails_helper'

shared_examples "user with access to content" do
  it 'can get content' do
    get path, auth_params(user)
    expect_response_to_have(response,sucess=true,status=:ok)
  end

  it 'cannot get if email is missing' do
    user.email=""
    get path, auth_params(user)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot get if token is missing' do
    user.authentication_token=""
    get path, auth_params(user)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot get if email is wrong' do
    user.email="user@wrong.com"
    get path, auth_params(user)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'cannot get if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    get path, auth_params(user)
    expect_response_to_have(response,sucess=false,status=:unauthorized)
  end

  it 'can get content list' do
    (1..3).to_a.each{|x| create(:user)}
    (1..10).to_a.each{|x| create(:content, user_id: "1")}
    get path, auth_params(user)
    expect_response_to_have(response,sucess=true,status=:ok)
    expect(json.count).to eq(10)
  end

  it 'can get content list' do
    (1..3).to_a.each{|x| create(:user)}
    (1..19).to_a.each{|x| create(:content, user_id: "1")}
    get path, auth_params(user)
    expect_response_to_have(response,sucess=true,status=:ok)
    expect(json.count).to eq(19)
  end

  it 'can post content' do
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    expect_response_to_have(response,sucess=true,status=:created)
    # check that the attributes are the same.
    expect(json['content']).to include('id','user_id','content_category_id','text','photo_token')
    expect(json['content']).not_to include('kill_response','no_response','spread_response','spread_count')
    expect(json['content']['id']).not_to be nil
    expect(json['content']['user_id']).to eq(user.id)
    expect(json['content']['content_category_id']).to eq(content.content_category_id)
    expect(json['content']['text']).to eq(content.text)
    expect(json['content']['photo_token']).to be nil
  end

  it 'cannot post content without user email' do
    post path, user.as_json(root: true, only: [:authentication_token]).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    # test for the 200 status-code
    expect(response).not_to be_success
    expect(response).to have_http_status(:unauthorized)
  end

  it 'cannot post content with empty user email' do
    user.email =""
    content = build(:content, user_id: nil)
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    # test for the 200 status-code
    expect(response).not_to be_success
    expect(response).to have_http_status(:unauthorized)
  end

  it 'cannot post content without user auth token' do
    content = build(:content, user_id: nil)
    post path, user.as_json(root: true, only: [:email]).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    # test for the 200 status-code
    expect(response).not_to be_success
    expect(response).to have_http_status(:unauthorized)
  end

  it 'cannot post content with empty auth token' do
    user.authentication_token =""
    content = build(:content, user_id: nil)
    post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
    # test for the 200 status-code
    expect(response).not_to be_success
    expect(response).to have_http_status(:unauthorized)
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

end

describe "API " do
  let(:path) {"/api/v0/contents"}
  let(:content){build(:content, user_id: nil)}

  describe "Content: normal user" do
    let(:user) {create :user}
    it_behaves_like  "user with access to content"
  end
  describe "Content: anonymous user" do
    let(:user) {get_user_anonymous}
    it_behaves_like  "user with access to content"
  end

end
