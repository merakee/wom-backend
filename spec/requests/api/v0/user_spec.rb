require 'rails_helper' 

describe "User API" do
  #let(:user) { FactoryGirl.create(:user) }
   before do
     allow_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(nil)
     #expect_any_instance_of(API::V0::UsersController).to receive(:authenticate_user!).and_return(true)
   end
  
  it 'retrieves list of users' do
    #sign_in users[0] 
    nusers = 1
    users = FactoryGirl.create_list(:user, nusers)  
    #get "/api/v0/users/", :user => users[0]
    #puts users[0][:authentication_token]
    get "/api/v0/users/"#, :email => users[0][:email],:authentication_token => users[0][:authentication_token]

    # test for the 200 status-code
    expect(response).to be_success
    #puts json
    expect(json.count).to eq(nusers)
    # check that the message attributes are the same.
    #expect(json['content']).to eq(message.content) 
  end
end