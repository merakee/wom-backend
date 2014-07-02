require 'rails_helper'

describe "API Registration" do
#before do
#allow_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(nil)
#expect_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(true)
#end

  describe "Sign up" do
    let(:path) {"api/v0/sign_up"}
    let(:user){{user:{email:"usernew@email.com",password:"password",password_confirmation:"password",user_type_id:2}}}
    
    it "should create user and get token" do
      post path, user.as_json(root: true)
      # test for  status-code
      expect(response).to be_success
      # check that the attributes are the same.
      expect(response).to have_http_status(:created)
      expect(json["user"]["id"]).not_to be_nil
      expect(json["user"]["user_type_id"]).to eq(user[:user][:user_type_id])
      expect(json["user"]["email"]).to eq(user[:user][:email])
      expect(json["user"]["authentication_token"]).not_to be_nil
    end

    it "should fail without email" do
      user[:user].delete(:email)
      post path, user.as_json(root: true)
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end


    it "should fail with empty email" do
      user[:user][:email]=""
      post path, user.as_json(root: true)
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end
  
    it "should fail with wrong email format" do
     user[:user][:email] ="this@wrongcom"
      post path, user.as_json(root: true)
      # test for status-code
      expect(response).not_to be_success
      expect(response).to have_http_status(:unprocessable_entity)
    end
    
      it "should fail without password" do
      user[:user].delete(:password)
      post path, user.as_json(root: true)
        # test for status-code
        expect(response).not_to be_success
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
      it "should fail with empty password" do
      user[:user][:password]=""
      post path, user.as_json(root: true)
        # test for status-code
        expect(response).not_to be_success
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
      it "should fail with non matching passwords" do
      user[:user][:password]="Password"
      post path, user.as_json(root: true)
        # test for status-code
        expect(response).not_to be_success
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
     it "should fail without password confirmation" do
        user[:user].delete(:password_confirmation)
        post path, user.as_json(root: true)
        # test for status-code
        expect(response).not_to be_success
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
      it "should fail with empty passwordpassword_confirmation" do
        user[:user][:password_confirmation]=""
        post path, user.as_json(root: true)
        # test for status-code
        expect(response).not_to be_success
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "should fail with non matching password_confirmation " do
        user[:user][:password_confirmation]="Password"
        post path, user.as_json(root: true)
        # test for status-code
        expect(response).not_to be_success
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      
      it "should fail with empty email and password" do
        user[:user].delete(:email)
        user[:user].delete(:password)
        post path, user.as_json(root: true)
        # test for status-code
        expect(response).not_to be_success
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
  end
end

