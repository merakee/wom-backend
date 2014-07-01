require 'rails_helper'

describe "API " do
  
  describe "Content " do
    let(:path) {"/api/v0/contents"}
    let(:auth_user){authenticated_user}
    
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
     
    
  end
end
