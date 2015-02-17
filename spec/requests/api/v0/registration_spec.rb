require 'rails_helper'

def should_register_user_and_return_token(path, user, msg=nil)
  post path, user.as_json(root: true)
  expect_response_to_have(response,sucess=true,status=:created,msg=msg)
  expect(json["user"]["id"]).not_to be_nil
  expect(json["user"]["user_type_id"]).to eq(user[:user][:user_type_id]) if user[:user][:user_type_id].is_a?(Fixnum)
  expect(json["user"]["email"]).to eq(user[:user][:email])
  expect(json["user"]["authentication_token"]).not_to be_nil
end

def should_fail_with_unprocessable_entity(path, user, msg=nil)
  post path, user.as_json(root: true)
  expect_response_to_have(response,sucess=false,status=:unprocessable_entity,msg=msg)
  response
end

def should_register_anonymous_user_and_return_token(path, user, msg=nil)
  post path, user.as_json(root: true)
  expect_response_to_have(response,sucess=true,status=:created,msg=msg)
  expect(json["user"]["id"]).not_to be_nil
  expect(json["user"]["user_type_id"]).to eq(user[:user][:user_type_id])
  expect(json["user"]["email"]).to eq("#{json["user"]["authentication_token"].downcase}@email.com")
  expect(json["user"]["authentication_token"]).not_to be_nil
end

 def should_have_follwoing_fileds_in_message(email=false,password=false,password_confirmation=false)
  expect(json['message']['email']).not_to be_nil if(email) 
  expect(json['message']['password']).not_to be_nil if(password)
  expect(json['message']['password_confirmation']).not_to be_nil if(password_confirmation)
end

describe "API Registration" do
  let(:path) {"api/v0/signup"}
  let(:user){{user:{email:"usernew@email.com",password:"password",password_confirmation:"password",user_type_id:2}}}
  let(:user_anon_type){{user:{email:"useranon@email.com",password:"password",password_confirmation:"password",user_type_id:1}}}

  describe "Sign up" do
   
   it "should create user and get token" do
    should_register_user_and_return_token(path, user)
    end

    it "should fail without email" do
      user[:user].delete(:email)
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(true)
    end

   it "should fail with empty email" do
      user[:user][:email]=""
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(true)
    end

    it "should fail with wrong email format" do
      user[:user][:email] ="this@wrongcom"
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(true)
    end

    it "should fail without password" do
      user[:user].delete(:password)
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(false,true)
    end

    it "should fail with empty password" do
      user[:user][:password]=""
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(false,true)
    end

    it "should fail with non matching passwords" do
      user[:user][:password]="Password"
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(false,false,true)
    end

    xit "should fail without password confirmation" do
      user[:user].delete(:password_confirmation)
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(false,false,true)
    end

    it "should fail with empty passwordpassword_confirmation" do
      user[:user][:password_confirmation]=""
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(false,false,true)
    end

    it "should fail with non matching password_confirmation " do
      user[:user][:password_confirmation]="Password"
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(false,false,true)
    end

    it "should fail with empty email and password" do
      user[:user].delete(:email)
      user[:user].delete(:password)
      should_fail_with_unprocessable_entity(path, user)
      should_have_follwoing_fileds_in_message(true,true,true)
    end

    it "should accept numbers and string for user_type_id" do
      user[:user][:user_type_id]="2"
      should_register_user_and_return_token(path, user)
    end
  end
  
  describe "Sign up for anonymous" do
    
    it "should create user and get token" do
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass without email" do
      user_anon_type[:user].delete(:email)
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass with empty email" do
      user_anon_type[:user][:email]=""
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass with wrong email format" do
      user_anon_type[:user][:email] ="this@wrongcom"
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass without password" do
      user_anon_type[:user].delete(:password)
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass with empty password" do
      user_anon_type[:user][:password]=""
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass with non matching passwords" do
      user_anon_type[:user][:password]="Password"
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass without password confirmation" do
      user_anon_type[:user].delete(:password_confirmation)
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass with empty passwordpassword_confirmation" do
      user_anon_type[:user][:password_confirmation]=""
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass with non matching password_confirmation " do
      user_anon_type[:user][:password_confirmation]="Password"
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end

    it "should pass with empty email and password" do
      user_anon_type[:user].delete(:email)
      user_anon_type[:user].delete(:password)
      should_register_anonymous_user_and_return_token(path, user_anon_type)
    end
  end
  
  describe "Sign up unknown user" do
    it "should fail with msg" do
      user[:user][:user_type_id]=3
      should_fail_with_unprocessable_entity(path, user,"Unknown user type")
    end
  end
  
end

