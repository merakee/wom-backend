describe "User API" do
  #let(:user) { FactoryGirl.create(:user) }
  
  it 'retrieves list of users' do
    nusers = 5
    FactoryGirl.create_list(:user, nusers)   
    get "/api/v0/users/"

    # test for the 200 status-code
    expect(response).to be_success
    puts json
    expect(json.count).to eq(nusers)
    
    
    # check that the message attributes are the same.
    #expect(json['content']).to eq(message.content) 
  end
end