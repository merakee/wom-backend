require 'rails_helper'

describe "API " do
  
  describe "Comment Response " do
    let(:path) {"/api/v0/comments/response"}
    let(:user_content){create(:user)}
    let(:user){create(:user)}
    let(:content){create(:content, user: user_content)}
    let(:comment){create(:comment, user: user_content, content: content)}
    let(:comment_response){build(:comment_response, user: user, comment: comment)}
    
   it 'can post comment_response' do
     for ind in 1..100 do 
       comment = create(:comment, user: user_content, content: content)
       comment_response= build(:comment_response, user: user, comment: comment)
       post path, auth_params(user).merge(comment_response.as_json(root: true, only: [:comment_id, :response])) 
       expect_response_to_have(response,sucess=true,status=:created)
       # check that the attributes are the same.
       expect(json['comment_response']).to include('id','comment_id','user_id','response') 
       expect(json['comment_response']['id']).not_to be nil
       expect(json['comment_response']['user_id']).to eq(user.id)
       expect(json['comment_response']['comment_id']).to eq(comment_response.comment_id)
       expect(json['comment_response']['response']).to eq(comment_response.response)
      end
     end
    
    it 'cannot post comment_response without user email' do
      post path, user.as_json(root: true, only: [:authentication_token]).
      merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
     end
     
     it 'cannot post comment_response without auth token' do
      post path, user.as_json(root: true, only: [:email]).
      merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
     end
     
     it 'cannot post comment_response with empty user email' do
     user.email =""
      post path, auth_params(user).merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
     end
     
     it 'cannot post comment_response with empty auth token' do
     user.authentication_token =""
      post path, auth_params(user).merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unauthorized)
     end

     it 'cannot post comment_response without user info ' do
      post path, comment_response.as_json(root: true, only: [:content_id, :response])
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
     end
     
      it 'cannot post comment_response with empty user info ' do
      post path, user.as_json(root: true, only: []).
      merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     
     it 'cannot post comment_response with nil comment_id' do
      comment_response.comment_id = nil
      post path, auth_params(user).merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     it 'cannot post comment_response with empty comment_id' do
      comment_response.comment_id = ""
      post path, auth_params(user).merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end

     it 'cannot post comment_response without comment_id' do
      comment_response.comment_id = ""
      post path, auth_params(user).merge(comment_response.as_json(root: true, only: [ :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
          
          
     it 'cannot post comment_response without reponse' do
      post path, auth_params(user).merge(comment_response.as_json(root: true, only: [:content_id]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     it 'cannot post comment_response with empty reponse' do
      comment_response.response = ""
      post path, auth_params(user).merge(comment_response.as_json(root: true, only: [:comment_id, :response]))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
     
     it 'cannot post the same comment_response' do
      post path, auth_params(user).merge(comment_response.as_json(root: true))
      post path, auth_params(user).merge(comment_response.as_json(root: true))
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
     end
          
  end
end
