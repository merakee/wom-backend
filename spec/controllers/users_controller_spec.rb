require 'rails_helper'

describe API::V0::UsersController do
  login_user

  xit "should have a current_user" do
  # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).to be 
  end

  it "should get index" do
  # Note, rails 3.x scaffolding may add lines like get :index, {}, valid_session
  # the valid_session overrides the devise login. Remove the valid_session from your specs
    get :index
    expect(response.status).to eq(200)
  end
end