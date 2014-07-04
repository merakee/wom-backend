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
      expect(:get =>  "api/v0/sign_up").not_to be_routable
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
      expect(:get =>  "api/v0/sign_in").not_to be_routable
    end

    specify "sign out" do
      expect(:delete =>  "api/v0/sign_out").to route_to(
      :controller => "api/v0/sessions",
      :action => "destroy",
      :format =>:json)
    end
    specify "sign out via get" do
      expect(:get =>  "api/v0/sign_out").not_to be_routable
    end
    specify "sign out via post" do
      expect(:post =>  "api/v0/sign_out").not_to be_routable
    end
    
  end

  describe "User Paths: " do
    specify "show" do
      expect(:get =>  "api/v0/users/10").to route_to(
      :controller => "api/v0/users",
      :action => "show",
      :format =>:json,
      :id => "10")
    end

    it "show without id" do
      expect(:get =>  "api/v0/users/").not_to be_routable
    end
    it "show via post" do
      expect(:post =>  "api/v0/users/12").not_to be_routable
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
      expect(:get => "api/v0/user_responses").not_to be_routable
    end

  end

end
