# require 'rails_helper'
# 
# def fail_with_unauthorized(path,user)
  # get path, auth_params(user)
  # expect_response_to_have(response,sucess=false,status=:unauthorized)
# end
# 
# describe "API " do
  # let(:path) {"api/v0/profile"}
  # let(:auth_user){create :user}
# 
  # describe "User " do
    # it 'gets user info' do
      # get path, auth_params(auth_user)
      # # test for the 200 status-code
      # expect(response).to be_success
      # # check that the attributes are the same.
      # expect(json['user']['id']).to eq(auth_user.id)
      # expect(json['user']['email']).to eq(auth_user.email)
      # expect(json['user']['userid']).to eq(auth_user.userid)
      # expect(json['user']['authentication_token']).to eq(auth_user.authentication_token)
      # expect(json['user']['user_type_id']).to eq(auth_user.user_type_id)
    # end
# 
    # it 'cannot get if email is missing' do
      # user=auth_user.dup
      # user.email=""
      # fail_with_unauthorized(path,user)
    # end
# 
    # it 'cannot get if token is missing' do
      # user=auth_user.dup
      # user.authentication_token=""
      # fail_with_unauthorized(path,user)
    # end
# 
    # it 'cannot get if email is wrong' do
      # user=auth_user.dup
      # user.email="user@wrong.com"
      # fail_with_unauthorized(path,user)
    # end
# 
    # it 'cannot get if token is wrong' do
      # user=auth_user.dup
      # user.authentication_token = auth_user.authentication_token.chop
      # fail_with_unauthorized(path,user)
    # end
# 
    # it 'anomymous user cannot get profile' do
      # get path, auth_params(get_user_anonymous)
      # expect_response_to_have(response,sucess=false,status=:bad_request)
    # end
  # end
# 
# end
# 
