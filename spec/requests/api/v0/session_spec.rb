require 'rails_helper'

describe "API Session " do
#before do
#allow_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(nil)
#expect_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(true)
#end

  describe "Sign in" do
    let(:path) {"api/v0/sign_in"}
    let(:auth_user){FactoryGirl.create(:user)}

    it "should get token" do
      post path, { user: {email:auth_user.email, password:"password"} }.as_json
      # test for  status-code
      expect(response).to be_success
      # check that the attributes are the same.
      expect(response).to have_http_status(:ok)
      expect(json["user"]["id"]).to eq(auth_user.id)
      expect(json["user"]["email"]).to eq(auth_user.email)
      expect(json["user"]["authentication_token"]).to eq(auth_user.authentication_token)
    end

    it "should fail without email" do
      post path, { user: {password:"password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should fail with empty email" do
      post path, { user: {email:"", password:"password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should fail with wrong email" do
      post path, { user: {email:"1"+auth_user.email, password:"password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it "should fail without password" do
      post path, { user: {email:auth_user.email} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it "should fail with empty password" do
      post path, { user: {email:auth_user.email, password:""} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it "should fail with wrong password" do
      post path, { user: {email:auth_user.email, password:"Password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
    end

    it "should fail with empty email and password" do
      post path, { user: {email:"", password:""} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "Sign out" do
    let(:path) {"api/v0/sign_out"}
    let(:auth_user){FactoryGirl.create(:user)}
    let(:token){auth_user.authentication_token}

    it "should fail without email" do
      delete path, { user: {authentication_token:token} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should fail with empty email" do
      delete path, { user: {email:"", authentication_token:token} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should fail with wrong email" do
      delete path, { user: {email:"1"+auth_user.email, authentication_token:token} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
    end

    it "should fail without token" do
      delete path, { user: {email:auth_user.email} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
    end

    it "should fail with empty token" do
      delete path, { user: {email:auth_user.email, authentication_token:""} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
    end

    it "should fail with wrong token" do
      delete path, { user:{email:auth_user.email, authentication_token:token+"1"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
    end

    it "should fail with empty email and token" do
      delete path, { user: {email:"", authentication_token:""} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should be sucessful" do
      delete path, { user: {email:auth_user.email, authentication_token:token} }.as_json
      # test for  status-code
      expect(response).to be_success
      # check that the attributes are the same.
      expect(response).to have_http_status(:ok)
    end

    it "should fail with old token" do
      delete path, { user: {email:auth_user.email, authentication_token:token} }.as_json
      delete path, { user: {email:auth_user.email, authentication_token:token} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
    end

  end

end
