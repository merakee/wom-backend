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
      expect(:post =>  "api/v0/sign_up").to route_to(
      :controller => "api/v0/registrations",
      :action => "create",
      :format =>:json)
    end

    it "sign up via get" do
      expect(:get =>  "api/v0/sign_up").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/sign_up")
    end

  end

  describe "Session Paths: " do
    specify "sign in" do
      expect(:post =>  "api/v0/sign_in").to route_to(
      :controller => "api/v0/sessions",
      :action => "create",
      :format =>:json)
    end
    specify "sign in via get" do
      expect(:get =>  "api/v0/sign_in").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/sign_in")
    end

    specify "sign out" do
      expect(:delete =>  "api/v0/sign_out").to route_to(
      :controller => "api/v0/sessions",
      :action => "destroy",
      :format =>:json)
    end
    specify "sign out via get" do
      expect(:get =>  "api/v0/sign_out").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/sign_out")
    end
    specify "sign out via post" do
      expect(:post =>  "api/v0/sign_out").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/sign_out")
    end
    
  end

  describe "User Paths: " do
    specify "show" do
      expect(:get =>  "api/v0/profile").to route_to(
      :controller => "api/v0/users",
      :action => "show",
      :format =>:json)
    end

    it "show via delete" do
      expect(:delete =>  "api/v0/profile").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/profile")
    end
    it "show via post" do
      expect(:post =>  "api/v0/profile").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/profile")
    end

  end

  describe "Content Paths: " do
    specify "index" do
      expect(:get =>  "api/v0/contents").to route_to(
      :controller => "api/v0/contents",
      :action => "index",
      :format =>:json)
    end

    specify "create" do
      expect(:post =>  "api/v0/contents").to route_to(
      :controller => "api/v0/contents",
      :action => "create",
      :format =>:json)
    end

  end

  describe "User Response Paths: " do
    specify "create" do
      expect(:post =>  "api/v0/user_responses").to route_to(
      :controller => "api/v0/user_responses",
      :action => "create",
      :format =>:json)
    end

    it "create via get" do
      expect(:get => "api/v0/user_responses").to route_to(
      :controller => "application",
      :action => "routing_error",
      :format =>:json,
      :all => "api/v0/user_responses")
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
