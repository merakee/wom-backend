require 'rails_helper'

describe "API " do
  
  describe "User Response " do
    let(:path) {"/api/v0/contents/response"}
    let(:user_content){create(:user)}
    let(:user){create(:user)}
    let(:content){create(:content, user_id: user_content.id)}
    let(:user_response){build(:user_response, content_id: content.id)}
    
   it 'can post user_response' do
     for ind in 1..100 do 
       content = create(:content, user_id: user_content.id)
       user_response= build(:user_response, content_id: content.id)
       post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
        expect_response_to_have(response,sucess=true,status=:created)
        # check that the attributes are the same.
        expect(json['content_response']).to include('id','user_id','content_id','response')
        expect(json['content_response']['id']).not_to be nil
        expect(json['content_response']['user_id']).to eq(user.id)
        expect(json['content_response']['content_id']).to eq(user_response.content_id)
        expect(json['content_response']['response']).to eq(user_response.response)
      end
     end
    
    it 'cannot post user_response without user email' do
      post path, user.as_json(root: true, only: [:authentication_token]).
      merge(user_response.as_json(root: true, only: [:content_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
     end
     
     it 'cannot post user_response without auth token' do
      post path, user.as_json(root: true, only: [:email]).
      merge(user_response.as_json(root: true, only: [:content_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
     end
     
     it 'cannot post user_response with empty user email' do
     user.email =""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
     end
     
     it 'cannot post user_response with empty auth token' do
     user.authentication_token =""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
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
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     
     it 'cannot post user_response with nil content_id' do
      user_response.content_id = nil
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     it 'cannot post user_response with empty content_id' do
      user_response.content_id = ""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end

     it 'cannot post user_response without content_id' do
      user_response.content_id = ""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [ :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
          
          
     it 'cannot post user_response without reponse' do
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     it 'cannot post user_response with empty reponse' do
      user_response.response = ""
      post path, auth_params(user).merge(user_response.as_json(root: true, only: [:content_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     it 'cannot post the same user_response' do
      post path, auth_params(user).merge(user_response.as_json(root: true))
      post path, auth_params(user).merge(user_response.as_json(root: true))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
          
  end
end
