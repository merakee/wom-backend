require 'rails_helper'

describe "API Session " do
#before do
#allow_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(nil)
#expect_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(true)
#end
let(:user){create(:user)}
let(:path_sign_in) {"api/v0/signin"}
let(:path_sign_out) {"api/v0/signout"}
        
  describe "Sign in" do
    
     it "should get token" do
      post path_sign_in, {user: {email: user.email, password:user.password} }.as_json
      expect_response_to_have(response,sucess=true,status=:ok)
      expect(json["user"]["id"]).not_to be_nil 
      expect(json["user"]["email"]).to eq(user.email)
      expect(json["user"]["authentication_token"]).to eq(user.authentication_token)
    end

    it "should fail without email" do
      post path_sign_in, {user: { password:"password"} }.as_json
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity,msg="Missing login email parameter")
    end
    
    it "should fail with empty email" do
      post path_sign_in, {user: {email: "", password:"password"} }.as_json
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity,msg="Missing login email parameter")
    end

    it "should fail with wrong email" do
      user.email +='1'
      post path_sign_in, {user: {email: user.email, password:"password"} }.as_json
      expect_response_to_have(response,sucess=false,status=:unauthorized,msg="Invalid email")
    end

    it "should fail without password" do
      post path_sign_in, {user: {email: user.email} }.as_json
      expect_response_to_have(response,sucess=false,status=:unauthorized,msg="Invalid password")
    end

    it "should fail with empty password" do
      post path_sign_in, {user: {email: user.email, password:""} }.as_json
      expect_response_to_have(response,sucess=false,status=:unauthorized,msg="Invalid password")
    end

    it "should fail with wrong password" do
      post path_sign_in, {user: {email: user.email, password:"Password"} }.as_json
      expect_response_to_have(response,sucess=false,status=:unauthorized,msg="Invalid password")
    end

    it "should fail with empty email and password" do
      post path_sign_in, {user: {email: "", password:""} }.as_json
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity,msg="Missing login email parameter")
    end
  end

  describe "Sign out"  do
    
    it "should fail without email" do
      delete path_sign_out, user.as_json(root: true, only: [:authentication_token])
      #puts response 
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity,msg="Missing login email parameter")
    end

    it "should fail with empty email" do
      user.email =""
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity,msg="Missing login email parameter")
    end

    it "should fail with wrong email" do
      user.email +="1"
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      expect_response_to_have(response,sucess=false,status=:bad_request,msg="Unauthorized user")
    end

    it "should fail without token" do
      delete path_sign_out, user.as_json(root: true, only: [:email])
      expect_response_to_have(response,sucess=false,status=:bad_request,msg="Unauthorized user")
    end

    it "should fail with empty token" do
      user.authentication_token=""
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      expect_response_to_have(response,sucess=false,status=:bad_request,msg="Unauthorized user")
    end

    it "should fail with wrong token" do
      user.authentication_token +="a"
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      expect_response_to_have(response,sucess=false,status=:bad_request,msg="Unauthorized user")
    end

    it "should fail with empty email and token" do
      user.authentication_token=""
      user.email=""
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity,msg="Missing login email parameter")
    end

    it "should be sucessful" do
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      expect_response_to_have(response,sucess=true,status=:ok,msg="Authetication token deleted")
    end

    it "should be sucessful and change token" do
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      post path_sign_in, {user: {email: user.email, password:user.password} }.as_json
      expect_response_to_have(response,sucess=true,status=:ok)
      expect(json["user"]["id"]).not_to be_nil 
      expect(json["user"]["email"]).to eq(user.email)
      expect(json["user"]["authentication_token"]).not_to eq(user.authentication_token)    
    end
    
    it "cannot log in with old token" do
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      delete path_sign_out, user.as_json(root: true, only: [:email,:authentication_token])
      expect_response_to_have(response,sucess=false,status=:bad_request,msg="Unauthorized user")  
    end
    
     it "should fail for anonymous user" do
     delete path_sign_out, get_user_anonymous.as_json(root: true, only: [:email,:authentication_token])
     expect_response_to_have(response,sucess=false,status=:bad_request,msg="Not a valid action for this user")
    end
  end
end
