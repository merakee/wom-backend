require 'rails_helper'

describe "Routes for" do

  describe "Root Paths: " do
    specify "root" do
      expect(:get =>  "/").to route_to(
      :controller => "api/v0/sessions",
      :action => "create")
    end

    specify "api root" do
      expect(:get =>  "api/v0").to route_to(
      :controller => "api/v0/sessions",
      :action => "create",
      :format =>:json)
    end
  end

  describe "Registration Paths: " do
    specify "sign up" do
      expect(:post =>  "api/v0/signup").to route_to(
      :controller => "api/v0/registrations",
      :action => "create",
      :format =>:json)
    end

    it "sign up via get" do
      expect(:get =>  "api/v0/signup").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/signup")
    end

  end

  describe "Session Paths: " do
    specify "sign in" do
      expect(:post =>  "api/v0/signin").to route_to(
      :controller => "api/v0/sessions",
      :action => "create",
      :format =>:json)
    end
    specify "sign in via get" do
      expect(:get =>  "api/v0/signin").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/signin")
    end

    specify "sign out" do
      expect(:delete =>  "api/v0/signout").to route_to(
      :controller => "api/v0/sessions",
      :action => "destroy",
      :format =>:json)
    end
    specify "sign out via get" do
      expect(:get =>  "api/v0/signout").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/signout")
    end
    specify "sign out via post" do
      expect(:post =>  "api/v0/signout").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/signout")
    end

  end

  describe "User Paths: " do
    specify "profile" do
      expect(:post =>  "api/v0/users/profile").to route_to(
      :controller => "api/v0/users",
      :action => "profile",
      :format =>:json)
    end

    it "update" do
      expect(:post =>  "api/v0/users/update").to route_to(
      :controller => "api/v0/users",
      :action => "update",
      :format =>:json)
    end

  end

  describe "Content Paths: " do
    specify "index via get" do
      expect(:get =>  "api/v0/contents/getlist").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/contents/getlist")
    end

    specify "create" do
      expect(:post =>  "api/v0/contents/create").to route_to(
      :controller => "api/v0/contents",
      :action => "create",
      :format =>:json)
    end

    specify "index" do
      expect(:post =>  "api/v0/contents/getlist").to route_to(
      :controller => "api/v0/contents",
      :action => "index",
      :format =>:json)
    end
    
    specify "getcontent" do
      expect(:post =>  "api/v0/contents/getcontent").to route_to(
      :controller => "api/v0/contents",
      :action => "get_content",
      :format =>:json)
    end 
    
    specify "getcontentrecent" do
      expect(:post =>  "api/v0/contents/getrecent").to route_to(
      :controller => "api/v0/contents",
      :action => "get_recent",
      :format =>:json)
    end 
    
    specify "deletecontent" do
      expect(:post =>  "api/v0/contents/delete").to route_to(
      :controller => "api/v0/contents",
      :action => "destroy",
      :format =>:json)
    end 
    
  end

  describe "User Response Paths: " do
    specify "create" do
      expect(:post =>  "api/v0/contents/response").to route_to(
      :controller => "api/v0/user_responses",
      :action => "create",
      :format =>:json)
    end

    it "create via get" do
      expect(:get => "api/v0/contents/response").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/contents/response")
    end

  end
  
  describe "Favorite Content Paths: " do
    specify "favorite" do
      expect(:post =>  "api/v0/favorite_contents/favorite").to route_to(
      :controller => "api/v0/favorite_contents",
      :action => "create",
      :format =>:json)
    end
    
    
    specify "unfavorite" do
      expect(:post =>  "api/v0/favorite_contents/unfavorite").to route_to(
      :controller => "api/v0/favorite_contents",
      :action => "destroy",
      :format =>:json)
    end

    specify "getlist" do
      expect(:post =>  "api/v0/favorite_contents/getlist").to route_to(
      :controller => "api/v0/favorite_contents",
      :action => "getlist",
      :format =>:json)
    end
    
  end
  
  
  describe "Content Flag Paths: " do
    specify "flag" do
      expect(:post =>  "api/v0/contents/flag").to route_to(
      :controller => "api/v0/content_flag",
      :action => "create",
      :format =>:json)
    end  
  end
  
  describe "Comment Paths: " do
    it "index via get" do
      expect(:get => "api/v0/comments/getlist").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/comments/getlist")
    end
    
    specify "index" do
      expect(:post =>  "api/v0/contents/getlist").to route_to(
      :controller => "api/v0/contents",
      :action => "index",
      :format =>:json)
    end
    specify "create" do
      expect(:post =>  "api/v0/comments/create").to route_to(
      :controller => "api/v0/comments",
      :action => "create",
      :format =>:json)
    end

  end

  describe "Comment Response Paths: " do
    specify "create" do
      expect(:post =>  "api/v0/comments/response").to route_to(
      :controller => "api/v0/comment_responses",
      :action => "create",
      :format =>:json)
    end

    it "create via get" do
      expect(:get => "api/v0/comments/response").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/comments/response")
    end

  end


  describe "History Contents Paths: " do
    specify "contents via post" do
      expect(:post =>  "api/v0/history/contents").to route_to(
      :controller => "api/v0/history",
      :action => "contents",
      :format =>:json)
    end

    it "contents via get" do
      expect(:get =>  "api/v0/history/contents").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/history/contents")
    end

  end

  describe "History Comments Paths: " do
    specify "comments via post" do
      expect(:post =>  "api/v0/history/comments").to route_to(
      :controller => "api/v0/history",
      :action => "comments",
      :format =>:json)
    end

    it "comments via get" do
      expect(:get =>  "api/v0/history/comments").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/history/comments")
    end

  end


  describe "Notification Paths: " do
    specify "getlist" do
      expect(:post =>  "api/v0/notifications/getlist").to route_to(
      :controller => "api/v0/notifications",
      :action => "index",
      :format =>:json)
    end

    it "getlist via get" do
      expect(:get =>  "api/v0/notifications/getlist").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/notifications/getlist")
    end

    specify "count" do
      expect(:post =>  "api/v0/notifications/count").to route_to(
      :controller => "api/v0/notifications",
      :action => "count",
      :format =>:json)
    end

    it "count via get" do
      expect(:get =>  "api/v0/notifications/count").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/notifications/count")
    end
    
    specify "reset content" do
      expect(:post =>  "api/v0/notifications/reset/content").to route_to(
      :controller => "api/v0/notifications",
      :action => "content_reset",
      :format =>:json)
    end

    it "count via get" do
      expect(:get =>  "api/v0/notifications/reset/content").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/notifications/reset/content")
    end
    
    specify "reset comment" do
      expect(:post =>  "api/v0/notifications/reset/comment").to route_to(
      :controller => "api/v0/notifications",
      :action => "comment_reset",
      :format =>:json)
    end

    it "count via get" do
      expect(:get =>  "api/v0/notifications/reset/comment").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/notifications/reset/comment")
    end
    
   
    
  end
  
    
  
  describe "Random Paths: " do
    it "via get" do
      expect(:get => "some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "some/random/path/to/nowhere")
    end
    it "via get through api" do
      expect(:get => "api/v0/some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/some/random/path/to/nowhere")
    end
    it "via put" do
      expect(:put => "some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "some/random/path/to/nowhere")
    end
    it "via put through api" do
      expect(:put => "api/v0/some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/some/random/path/to/nowhere")
    end

    it "via delete" do
      expect(:delete => "some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "some/random/path/to/nowhere")
    end
    it "via delete through api" do
      expect(:delete => "api/v0/some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/some/random/path/to/nowhere")
    end

    it "via update" do
      expect(:update => "some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "some/random/path/to/nowhere")
    end
    it "via update through api" do
      expect(:update => "api/v0/some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/some/random/path/to/nowhere")
    end

    it "via patch" do
      expect(:patch => "some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "some/random/path/to/nowhere")
    end
    it "via patch through api" do
      expect(:patch => "api/v0/some/random/path/to/nowhere").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/some/random/path/to/nowhere")
    end
  end
end
