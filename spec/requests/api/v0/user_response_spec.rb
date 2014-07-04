require 'rails_helper'

describe "API " do
  
  describe "User Response " do
    let(:path) {"/api/v0/user_responses"}
    let(:user_content){FactoryGirl.create(:user)}
    let(:user){FactoryGirl.create(:user)}
    let(:content){FactoryGirl.create(:content, user_id: user_content.id)}
    let(:user_response){FactoryGirl.build(:user_response, content_id: content.id)}
    
   it 'can post user_response' do
     post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
     # test for the 200 status-code
      expect(response).to be_success
      expect(response).to have_http_status(:created)
      # check that the attributes are the same.
      expect(json['user_response']).to include('id','user_id','user_id','response')
      expect(json['user_response']['id']).not_to be nil
      expect(json['user_response']['user_id']).to eq(user.id)
      expect(json['user_response']['content_id']).to eq(user_response.content_id)
      expect(json['user_response']['response']).to eq(user_response.response)
     end
    
    it 'cannot post user_response without user email' do
      post path, user.as_json(root: true, only: [:authentication_token]).
      merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
     end
     
     it 'cannot post user_response without auth token' do
      post path, user.as_json(root: true, only: [:email]).
      merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
     end
     
     it 'cannot post user_response with empty user email' do
     user.email =""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
     end
     
     it 'cannot post user_response with empty auth token' do
     user.authentication_token =""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
     end

     it 'cannot post user_response without user info ' do
      post path, user_response.as_json(root: true, only: [:content_id, :response])
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
      it 'cannot post user_response with empty user info ' do
      post path, user.as_json(root: true, only: []).
      merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
     
     it 'cannot post user_response with nil content_id' do
      user_response.content_id = nil
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
     it 'cannot post user_response with empty content_id' do
      user_response.content_id = ""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end

     it 'cannot post user_response withoutcontent_id' do
      user_response.content_id = ""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [ :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
          
          
     xit 'cannot post user_response without reponse' do
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
     xit 'cannot post user_response with empty reponse' do
      user_response.response = ""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
  end
end