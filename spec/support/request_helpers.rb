module Requests

 module ResponseHelpers
    def expect_response_to_have(response,success=false, status=nil, msg=nil)
      if success==true
        expect(response).to be_success
      else
        expect(response).not_to be_success
      end
      if status
        expect(response).to have_http_status(status)
      end
      if msg
        expect(json['message']).to eq(msg)
      end
    end
    
    def get_user_anonymous
      signup = "api/v0/signup"
      user_anon = build :user, :anonymous
      post signup, user_anon.as_json(root: true)
      user_anon.id = json['user']['id']
      user_anon.email = json['user']['email']
      user_anon.authentication_token=json['user']['authentication_token']
      user_anon
    end
  end

  module JsonHelpers
    def set_request_to_json
      before(:each) do
        @request.env["HTTP_ACCEPT"] = "application/json"
        @request.env['CONTENT_TYPE'] = 'application/json'
      end
    end
        
    def auth_params(user)
      user.as_json(only: [:email, :authentication_token,:user_type_id], root: true)
    end

    def json
      JSON.parse(response.body)
    end
  end
end