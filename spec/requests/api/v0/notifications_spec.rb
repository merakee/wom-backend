require 'rails_helper'

def add_comments_for_notification(content, user,count=1)
  (1..count).to_a.each{|x| create(:comment, content: content, user: user)}
end

def add_likes_for_notification(comment,count=1)
  (1..count).to_a.each{|x| create(:comment_response, comment: comment)}
end

shared_examples "user with access to notifications count" do
  it 'can get count' do
    add_comments_for_notification(content, user, comment_count)
    add_likes_for_notification(comment,like_count)
    
    post count_path, auth_params(user)
    expect_response_to_have(response,sucess=true,status=:ok)
    expect(json["notifications"]).not_to be_nil
    expect(json['notifications']).to include("user_id", "total_new_count","new_comment_count","new_like_count")
    expect(json['notifications']['total_new_count']).to eq(comment_count+like_count+1)
    expect(json['notifications']['new_comment_count']).to eq(comment_count+1)
    expect(json['notifications']['new_like_count']).to eq(like_count)
  end
end

shared_examples "user with access to notifications list" do
  it 'can get list' do
    add_comments_for_notification(content, user, comment_count)
    add_likes_for_notification(comment,like_count)
    post list_path, auth_params(user)
    expect_response_to_have(response,sucess=true,status=:ok)
    nlist = json["notifications"]
    expect(nlist).not_to be_nil
    expect(nlist.count).to  eq(2)
    nlist.each{|item|
      if item.has_key?("content_category_id")
        expect(item).to include("id", "user_id", "content_category_id", "text", "photo_token", "total_spread", "spread_count", "kill_count", "comment_count", "created_at", "updated_at", "new_comment_count")
      expect(item["new_comment_count"]).to eq(comment_count+1)
      else
        expect(item).to include("id", "user_id", "content_id", "text", "like_count", "created_at", "updated_at", "new_like_count")
        expect(item["new_like_count"]).to eq(like_count)
      end
    }
  end
end

shared_examples "user with access to notifications reset" do
  it 'can reset comment count' do
    add_comments_for_notification(content, user, comment_count)
    
    post reset_content_path, auth_params(user).merge(params: {content_id: content.id, count: comment_count-3})
    expect_response_to_have(response,sucess=true,status=:ok)
    expect(json["content"]).not_to be_nil
    expect(json['content']['new_comment_count']).to eq(3)
    
    post reset_content_path, auth_params(user).merge(params: {content_id: content.id, count: 3})
    expect_response_to_have(response,sucess=true,status=:ok)
    expect(json["content"]).not_to be_nil
    expect(json['content']['new_comment_count']).to eq(0)  
  end
  
  it 'can not reset comment count with wrong parameters' do
    add_comments_for_notification(content, user, comment_count)
    post reset_content_path, auth_params(user).merge(params: {content_id: content.id, count:-3})
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"Missing or Invalid parameter(s)")
    
    post reset_content_path, auth_params(user).merge(params: {content_id: content.id, count:0})
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"Missing or Invalid parameter(s)")
    
    post reset_content_path, auth_params(user).merge(params: {content_id: content.id, count:5643656})
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"Missing or Invalid parameter(s)")
    
    expect(Content.where(id:content.id).pluck(:new_comment_count)[0]).to eq(comment_count)
    
  end
  
    it 'can reset like count' do
    add_likes_for_notification(comment, like_count)
    
    post reset_comment_path, auth_params(user).merge(params: {comment_id: comment.id, count: like_count-3})
    expect_response_to_have(response,sucess=true,status=:ok)
    expect(json["comment"]).not_to be_nil
    expect(json['comment']['new_like_count']).to eq(3)
    
    post reset_comment_path, auth_params(user).merge(params: {comment_id: comment.id, count: 3})
    expect_response_to_have(response,sucess=true,status=:ok)
    expect(json["comment"]).not_to be_nil
    expect(json['comment']['new_like_count']).to eq(0)  
  end
  
  it 'can not reset comment count with wrong parameters' do
    add_likes_for_notification(comment, like_count)
    
    post reset_comment_path, auth_params(user).merge(params: {comment_id: comment.id, count:-3})
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"Missing or Invalid parameter(s)")
    
    post reset_comment_path, auth_params(user).merge(params: {comment_id: comment.id, count:0})
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"Missing or Invalid parameter(s)")
    
    post reset_comment_path, auth_params(user).merge(params: {comment_id: comment.id, count:5643656})
    expect_response_to_have(response,sucess=false,status=:unprocessable_entity,"Missing or Invalid parameter(s)")
    
    expect(Comment.where(id:comment.id).pluck(:new_like_count)[0]).to eq(like_count)
  end
  
end

describe "API " do
  let(:count_path) {"/api/v0/notifications/count"}
  let(:list_path){"/api/v0/notifications/getlist"}
  let(:reset_content_path) {"/api/v0/notifications/reset/content"}
  let(:reset_comment_path){"/api/v0/notifications/reset/comment"}

  describe "Notification " do
    let(:user) {create :user}
    let(:content) {create :content, user: user}
    let(:comment) {create :comment, content: content, user: user}
    let(:comment_count){5+rand(20)}
    let(:like_count){5+rand(20)}

    it_behaves_like  "user with access to notifications count"
    it_behaves_like  "user with access to notifications list"
    it_behaves_like  "user with access to notifications reset"
  end

end
