require 'rails_helper'

def able_to_get_history_content(path,user,params,msg=nil)      
    post content_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=true,status=:ok,msg)
    expect(json["contents"]).not_to be_nil
    expect(json['contents'][0]).to include("id",'user_id','content_category_id','text','photo_token','kill_count','spread_count','total_spread','comment_count')
end

def not_able_to_get_history_content(path,user,params,msg=nil)
    post content_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=false,status=:unauthorized,msg)
end

def able_to_get_history_comment(path,user,params,msg=nil)      
    post comment_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=true,status=:ok,msg)
    expect(json["comments"]).not_to be_nil
    expect(json['comments'][0]).to include("id", "user_id", "content_id", "text", "like_count", "created_at")#, "did_like")
end

def not_able_to_get_history_comment(path,user,params,msg=nil)
    post comment_path, auth_params(user).merge(params)
    expect_response_to_have(response,sucess=false,status=:unauthorized,msg)
end

def add_content_for_history(count=1)
   (1..count).to_a.each{|x| create(:content, user: user)}
end

def add_comment_for_history(count=1)
   (1..count).to_a.each{|x| create(:comment, content: content, user: user)}
end

shared_examples "user with access to content history" do
  it 'can get content hostory' do
    add_content_for_history
    able_to_get_history_content(path,user,params)
  end

  it 'cannot get hostory if email is missing' do
    user.email=""
    not_able_to_get_history_content(path,user,params)
  end

  it 'cannot get hostory if token is missing' do
    user.authentication_token=""
    not_able_to_get_history_content(path,user,params)
  end

  it 'cannot get hostory if email is wrong' do
    user.email="user@wrong.com"
    not_able_to_get_history_content(path,user,params)
  end

  it 'cannot get hostory if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    not_able_to_get_history_content(path,user,params)
  end
  
  it 'can get hostory content list' do
    add_content_for_history(11)
    able_to_get_history_content(path,user,params)
    expect(json["contents"].count).to be >= 11
  end

end

shared_examples "user with access to comment history" do
  it 'can get hostory comment' do
    add_comment_for_history
    able_to_get_history_comment(path,user,params)
  end

  it 'cannot get hostory if email is missing' do
    user.email=""
    not_able_to_get_history_comment(path,user,params)
  end

  it 'cannot get hostory if token is missing' do
    user.authentication_token=""
    not_able_to_get_history_comment(path,user,params)
  end

  it 'cannot get hostory if email is wrong' do
    user.email="user@wrong.com"
    not_able_to_get_history_comment(path,user,params)
  end

  it 'cannot get hostory if token is wrong' do
    user.authentication_token = user.authentication_token.chop
    not_able_to_get_history_comment(path,user,params)
  end
  
  it 'can get hostory comment list' do
    add_comment_for_history(11)
    able_to_get_history_comment(path,user,params)
    expect(json["comments"].count).to be >= 11
  end

end

describe "API " do  
  let(:content_path) {"/api/v0/history/contents"}
  let(:comment_path){"/api/v0/history/comments"}

  describe "History " do  
    let(:user) {create :user}
    let(:content) {create :content}
    let(:params) {{params: {user_id: user.id}}}
    
    it_behaves_like  "user with access to content history"  
    it_behaves_like  "user with access to comment history"
  end

end
