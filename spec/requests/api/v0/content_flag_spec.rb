require 'rails_helper'

describe "API " do

  describe "Content Flag" do
    let(:flag_path) {"/api/v0/contents/flag"}
    let(:user_content){create(:user)}
    let(:user){create(:user)}
    let(:content){create(:content, user: user_content)}

    it 'can flag content' do
      #puts auth_params(user).merge({params:{content_id: content.id}})
      post flag_path, auth_params(user).merge({params:{content_id: content.id}})
      expect_response_to_have(response,sucess=true,status=:created)
      # check that the attributes are the same.
      expect(json['content_flag']).to include('id','content_id','user_id')
      expect(json['content_flag']['id']).not_to be nil
      expect(json['content_flag']['user_id']).to eq(user.id)
      expect(json['content_flag']['content_id']).to eq(content.id)
    end

    it 'flag count should increase' do
      count = Content.where(id: content.id).pluck(:flag_count)[0]
      (1..10).each { |ind|
        user1 = create(:user)
        post flag_path, auth_params(user1).merge(params:{content_id: content.id})
        expect_response_to_have(response,sucess=true,status=:created)
        # check that the attributes are the same.
        expect(json['content_flag']).to include('id','content_id','user_id')
        expect(json['content_flag']['id']).not_to be nil
        expect(json['content_flag']['user_id']).to eq(user1.id)
        expect(json['content_flag']['content_id']).to eq(content.id)
        count1 = Content.where(id: content.id).pluck(:flag_count)[0]
        expect(count1).to eq(count+ind)
    }
    end
    

    it 'cannot flag same content twice' do
      post flag_path, auth_params(user).merge(params:{content_id: content.id})
      post flag_path, auth_params(user).merge(params:{content_id: content.id})
      expect_response_to_have(response,sucess=false,status=:unprocessable_entity)
    end

  end
end
