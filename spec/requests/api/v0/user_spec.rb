require 'rails_helper'

describe "API " do
#before do
#allow_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(nil)
#expect_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(true)
#end

  describe "User " do
    let(:path) {"api/v0/users"}
    let(:auth_user){authenticated_user}

    it 'gets user info' do
      get path + "/#{auth_user.id}", auth_params(auth_user)
      # test for the 200 status-code
      expect(response).to be_success
      # check that the attributes are the same.
      expect(json['id']).to eq(auth_user.id)
      expect(json['email']).to eq(auth_user.email)
      expect(json['userid']).to eq(auth_user.userid)
      expect(json['authentication_token']).to eq(auth_user.authentication_token)
      expect(json['user_type_id']).to eq(auth_user.user_type_id)
    end

    it 'cannot get if email is missing' do
      user=auth_user.dup
      user.email=""
      get path+ "/#{auth_user.id}", auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it 'cannot get if token is missing' do
      user=auth_user.dup
      user.authentication_token=""
      get path+ "/#{auth_user.id}", auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it 'cannot get if email is wrong' do
      user=auth_user.dup
      user.email="user@wrong.com"
      get path+ "/#{auth_user.id}", auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it 'cannot get if token is wrong' do
      user=auth_user.dup
      user.authentication_token = auth_user.authentication_token.chop
      get path+ "/#{auth_user.id}", auth_params(user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it 'cannot get another user info' do
      get path + "/#{auth_user.id}+#{rand(100)+1}", auth_params(auth_user)
      # test for the 200 status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
