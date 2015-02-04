require 'rails_helper'

describe User do

  it "has a valid factory" do
  # Using the shortened version of FactoryGirl syntax.
  # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:user)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:user) {build(:user)}

  describe "ActiveModel validations" do

  # Basic validations
    it { expect(user).to validate_presence_of(:email)}
    it { expect(user).to validate_presence_of(:password)}
    #it { expect(user).to validate_presence_of(:password_confirmation)}
    it { expect(user).to validate_presence_of(:user_type)}
    it { expect(user).to validate_uniqueness_of(:email) }
    #it { expect(user).to validate_confirmation_of(:password) }  # Ensure two values match

    # Format validations
    it { expect(user).to allow_value("dhh@nonopinionated.com").for(:email) }
    it { expect(user).to_not allow_value("base@example").for(:email) }
    it { expect(user).to_not allow_value("blah").for(:email) }

  #it { expect(user).to allow_value(6).for(:user_type_id) }
  #it { expect(user).to_not allow_value(7).for(:user_type_id) }
  #it { expect(user).to_not allow_value(0).for(:user_type_id) }

  # Inclusion/acceptance of values
  it { expect(user).to ensure_length_of(:nickname).is_at_least(2).is_at_most(17) }
  it { expect(user).to ensure_length_of(:bio).is_at_least(1).is_at_most(100) }
  it { expect(user).to ensure_length_of(:hometown).is_at_least(1).is_at_most(40) }
    
  #it { expect(tumblog).to ensure_inclusion_of(:status).in_array(['draft', 'public', 'queue']) }
  #it { expect(tng_group).to ensure_inclusion_of(:age).in_range(18..35) }
  #it { expect(band).to ensure_length_of(:bio).is_at_least(25).is_at_most(1000) }
  #it { expect(tweet).to ensure_length_of(:content).is_at_most(140) }
  #it { expect(applicant).to ensure_length_of(:ssn).is_equal_to(9) }
  #it { expect(contract).to validate_acceptance_of(:terms) }  # For boolean values
  #it { expect(user).to validate_confirmation_of(:password) }  # Ensure two values match
  end

  describe "ActiveRecord associations" do
  # http://guides.rubyonrails.org/association_basics.html
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord

  # Performance tip: stub out as many on create methods as you can when you're testing validations
  # since the test suite will slow down due to having to run them all for each validation check.
  #
  # For example, assume a User has three methods that fire after one is created, stub them like this:
  #
  # before(:each) do
  #   User.any_instance.stub(:send_welcome_email)
  #   User.any_instance.stub(:track_new_user_signup)
  #   User.any_instance.stub(:method_that_takes_ten_seconds_to_complete)
  # end
  #
  # If you performed 5-10 validation checks against a User, that would save a ton of time.

  # Associations
    it { expect(user).to belong_to(:user_type) }
    it { expect(user).to have_many(:content).dependent(:destroy)  }
    it { expect(user).to have_many(:user_response).dependent(:destroy)  }

    # Read-only matcher
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveReadonlyAttributeMatcher
    #it { expect(asset).to have_readonly_attribute(:uuid) }

    # Databse columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    #it { expect(user).to have_db_column(:political_stance).of_type(:string).with_options(default: 'undecided', null: false)}
    it { expect(user).to have_db_column(:authentication_token).of_type(:string)}
    it { expect(user).to have_db_column(:sign_in_count).of_type(:integer)}

    it { expect(user).to have_db_column(:nickname).of_type(:string)}
    it { expect(user).to have_db_column(:avatar).of_type(:string)}
    it { expect(user).to have_db_column(:bio).of_type(:text)}
    it { expect(user).to have_db_column(:social_tags).of_type(:string)}
    it { expect(user).to have_db_column(:hometown).of_type(:string)}
    
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord:have_db_index
    it { expect(user).to have_db_index(:email).unique(:true)}
    #it { expect(user).to have_db_index(:userid).unique(:true)}
    it { expect(user).to have_db_index(:authentication_token).unique(:true)}
  end

  describe "public class methods" do
    it { expect(user).to respond_to(:ensure_authentication_token!) }
    it { expect(user).to respond_to(:reset_authentication_token!) }
  #it {expect(factory_instance.method_to_test).to eq(value_you_expect)

  end
end

=begin

it "should have a valid factory" do
expect(user).to be
end

it "should have an user id" do
expect(user.userid).to be
end

it "should have an email" do
expect(user.email).to be
end

it "should have a password" do
expect(user.password).to be
end

it "should have an auth token" do
expect(user.authentication_token).to be
end

it "should require an email address" do
expect(build(:user, email: "")).to_not be_valid
end

#it "should require an userid" do
# expect(build(:user, userid: nil)).to_not be_valid
#end

it "should accept valid email addresses" do
addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
addresses.each do |address|
expect(build(:user, email: address)).to be_valid
end
end

it "should reject invalid email addresses" do
addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
addresses.each do |address|
expect(build(:user, email: address)).to_not be_valid
end
end

it "should reject duplicate email addresses" do
create(:user, email: "user@example.com" )
expect(build(:user, email: "user@example.com" ).valid?).to_not be
end

it "should reject email addresses identical up to case" do
expect(build(:user, email: user.email.upcase)).to_not be_valid
end

it "should have a password attribute" do
expect(user.password).to be
end

#it "should have a password confirmation attribute" do
# expect(user.password_confirmation).to be
#end

it "should require a password" do
expect(build(:user, password: nil)).to_not be_valid
end

# it "should require a matching password confirmation" do
#  User.new(@attr.merge(:password_confirmation => "invalid")).
# should_not be_valid
#end

it "should reject short passwords" do
expect(build(:user, password: "aaaaa")).to_not be_valid
end

it "should have an encrypted password attribute" do
expect(user.encrypted_password).to be
end
end
=end

