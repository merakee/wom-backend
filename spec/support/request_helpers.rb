module Requests

  module AuthHelpers
    def new_user
      FactoryGirl.build(:user)
    end

    def authenticated_user
      FactoryGirl.create(:user)
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
      user.as_json(only: [:email, :authentication_token], root: true)
    end

    def json
      @json ||= JSON.parse(response.body)
    end
  end
end