require 'rails_helper'

describe "API Session " do
#before do
#allow_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(nil)
#expect_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(true)
#end
let(:user){create(:user)}

  describe "Sign in" do
    let(:path) {"api/v0/sign_in"}
    it "should get token" do
      post path, {user: {email: user.email, password:"password"} }.as_json
      # test for  status-code
      expect(response).to be_success
      # check that the attributes are the same.
      expect(response).to have_http_status(:ok)
      expect(json["user"]["id"]).to eq(user.id)
      expect(json["user"]["email"]).to eq(user.email)
      expect(json["user"]["authentication_token"]).to eq(user.authentication_token)
    end

    it "should fail without email" do
      post path, {user: { password:"password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['message']).to eq("Missing login email parameter")
    end

    it "should fail with empty email" do
      post path, {user: {email: "", password:"password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['message']).to eq("Missing login email parameter")
    end

    it "should fail with wrong email" do
      user.email +='1'
      post path, {user: {email: user.email, password:"password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
      expect(json['message']).to eq("Invalid email")
    end

    it "should fail without password" do
      post path, {user: {email: user.email} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
      expect(json['message']).to eq("Invalid password")
    end

    it "should fail with empty password" do
      post path, {user: {email: user.email, password:""} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
      expect(json['message']).to eq("Invalid password")
    end

    it "should fail with wrong password" do
      post path, {user: {email: user.email, password:"Password"} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unauthorized)
      expect(json['message']).to eq("Invalid password")
    end

    it "should fail with empty email and password" do
      post path, {user: {email: "", password:""} }.as_json
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['message']).to eq("Missing login email parameter")
    end
  end

  describe "Sign out" do
    let(:path) {"api/v0/sign_out"}
    
    it "should fail without email" do
      delete path, user.as_json(root: true, only: [:authentication_token])
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['message']).to eq("Missing login email parameter")
    end

    it "should fail with empty email" do
      user.email =""
      delete path, user.as_json(root: true, only: [:email,:authentication_token])
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['message']).to eq("Missing login email parameter")
    end

    it "should fail with wrong email" do
      user.email +="1"
      delete path, user.as_json(root: true, only: [:email,:authentication_token])
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
      expect(json['message']).to eq("Not valid user or token")
    end

    it "should fail without token" do
      delete path, user.as_json(root: true, only: [:email])
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
      expect(json['message']).to eq("Not valid user or token")
    end

    it "should fail with empty token" do
      user.authentication_token=""
      # test for status-code
      delete path, user.as_json(root: true, only: [:email,:authentication_token])
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
      expect(json['message']).to eq("Not valid user or token")
    end

    it "should fail with wrong token" do
      user.authentication_token +="a"
      delete path, user.as_json(root: true, only: [:email,:authentication_token])
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:bad_request)
      expect(json['message']).to eq("Not valid user or token")
    end

    it "should fail with empty email and token" do
      user.authentication_token=""
      user.email=""
      delete path, user.as_json(root: true, only: [:email,:authentication_token])
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['message']).to eq("Missing login email parameter")
    end

    it "should be sucessful" do
      delete path, user.as_json(root: true, only: [:email,:authentication_token])
      # test for  status-code
      expect(response).to be_success
      # check that the attributes are the same.
      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq("Authetication token deleted")
    end

    xit "should be sucessful and change token" do
      
    end
    
    xit "cannot log in with old token" do

    end

  end

end
