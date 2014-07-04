require 'rails_helper'

describe "API " do
  
  describe "Content " do
    let(:path) {"/api/v0/contents"}
    let(:auth_user){authenticated_user}
    let(:user) {FactoryGirl.create(:user)}
    let(:content){FactoryGirl.build(:content, user_id: nil)}
     
    it 'gets content' do
      get path, auth_params(auth_user)
      # test for the 200 status-code
      expect(response).to be_success
    end
    
     it 'cannot get if email is missing' do
      user=auth_user.dup
      user.email=""
      get path, auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(401)
    end

    it 'cannot get if token is missing' do
      user=auth_user.dup
      user.authentication_token=""
      get path, auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(401)
    end

    it 'cannot get if email is wrong' do
      user=auth_user.dup
      user.email="user@wrong.com"
      get path, auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(401)
    end

    it 'cannot get if token is wrong' do
      user=auth_user.dup
      user.authentication_token = auth_user.authentication_token.chop
      get path, auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(401)
    end
    
    it 'gets content list' do
      (1..3).to_a.each{|x| FactoryGirl.create(:user)}
      (1..10).to_a.each{|x| FactoryGirl.create(:content, user_id: "1")}
      get path, auth_params(auth_user)
      # test for the 200 status-code
      expect(response).to be_success
      expect(json.count).to eq(10)
   end
      
    it 'gets content list' do
      (1..3).to_a.each{|x| FactoryGirl.create(:user)}
      (1..19).to_a.each{|x| FactoryGirl.create(:content, user_id: "1")}
      get path, auth_params(auth_user)
      # test for the 200 status-code
      expect(response).to be_success
      expect(json.count).to eq(19)
    end
     
     it 'can post content' do
      post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
      # test for the 200 status-code
      expect(response).to be_success
      expect(response).to have_http_status(:created)
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
     content = FactoryGirl.build(:content, user_id: nil)
      post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
     end
     
     it 'cannot post content without user auth token' do
     content = FactoryGirl.build(:content, user_id: nil)
      post path, user.as_json(root: true, only: [:email]).merge(content.as_json(root: true, only: [:content_category_id, :text]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
     end
     
     it 'cannot post content with empty auth token' do
     user.authentication_token =""
     content = FactoryGirl.build(:content, user_id: nil)
      post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
     end

     it 'cannot post content without user info ' do
      post path, content.as_json(root: true, only: [:content_category_id, :text])
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
     it 'cannot post content with empty text' do
     content.text= ""
      post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
     it 'cannot post content without text' do
      post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
    it 'cannot post content with empty content_category_id' do
     content.content_category_id= nil
      post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
     it 'cannot post content without content_category_id' do
     content.user_id=nil
      post path, auth_params(user).merge(content.as_json(root: true, only: [:text]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
     
      it 'cannot post content with short text' do
     content.text= "1"
      post path, auth_params(user).merge(content.as_json(root: true, only: [:content_category_id, :text]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
               
  end
end
