require 'rails_helper'

describe API::V0::UsersController do
  login_user
  
  let(:user) {FactoryGirl.create(:user)}
  
  it "sign_up should be sucessful" do
    #@request.env["devise.mapping"] = Devise.mappings[:user]
    #user = FactoryGirl.create(:user)
    #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in user
    puts response.status
    puts respose.body 
    json = JSON.parse(response.body)
    puts json
    json.should include('success' => true, 'status' => 200)
  end
  
  xit "should have a current_user" do
  # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).to be
  end

  xit "should get index" do
  # Note, rails 3.x scaffolding may add lines like get :index, {}, valid_session
  # the valid_session overrides the devise login. Remove the valid_session from your specs
    get :index
    expect(response.status).to eq(200)
  end
end