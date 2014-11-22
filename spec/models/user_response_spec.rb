require 'rails_helper'

describe UserResponse do
  let(:user){create(:user)}
  let(:user_c){create(:user)}
  let(:content) {create(:content, user: user_c)}

  it "has a valid factory" do
  # Using the shortened version of FactoryGirl syntax.
  # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:user_response, user: user, content: content)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:user_response) {create(:user_response, user: user, content: content)}

  describe "ActiveModel validations" do

  # Basic validations
    it { expect(user_response).to validate_presence_of(:user)}
    #it { expect(user_response).to validate_presence_of(:response)}
    it { expect(user_response).to validate_presence_of(:content)}

    # Format validations
    it { expect(user_response).to allow_value(true).for(:response) }
    it { expect(user_response).to allow_value(false).for(:response) }
    it { expect(user_response).not_to allow_value(nil).for(:response) }
    it { expect(user_response).to validate_uniqueness_of(:user_id).scoped_to([:content_id]).with_message("User already responsed to this content. User cannot respond to the same content more than once.")}


  #it { expect(user_response).to_not allow_value("1er").for(:response) }

  #it { expect(user_response).to allow_value(6).for(:user_response_type_id) }
  #it { expect(user_response).to_not allow_value(7).for(:user_response_type_id) }
  #it { expect(user_response).to_not allow_value(0).for(:user_response_type_id) }

  # Inclusion/acceptance of values
  #it { expect(tumblog).to ensure_inclusion_of(:status).in_array(['draft', 'public', 'queue']) }
  #it { expect(tng_group).to ensure_inclusion_of(:age).in_range(18..35) }
  #it { expect(band).to ensure_length_of(:bio).is_at_least(25).is_at_most(1000) }
  #it { expect(tweet).to ensure_length_of(:user_response).is_at_most(140) }
  #it { expect(applicant).to ensure_length_of(:ssn).is_equal_to(9) }
  #it { expect(contract).to validate_acceptance_of(:terms) }  # For boolean values
  #it { expect(user_response).to validate_confirmation_of(:password) }  # Ensure two values match
  end

  describe "ActiveRecord associations" do
  # http://guides.rubyonrails.org/association_basics.html
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord

  # Performance tip: stub out as many on create methods as you can when you're testing validations
  # since the test suite will slow down due to having to run them all for each validation check.
  #
  # For example, assume a user_response has three methods that fire after one is created, stub them like this:
  #
  # before(:each) do
  #   user_response.any_instance.stub(:send_welcome_email)
  #   user_response.any_instance.stub(:track_new_user_response_signup)
  #   user_response.any_instance.stub(:method_that_takes_ten_seconds_to_complete)
  # end
  #
  # If you performed 5-10 validation checks against a user_response, that would save a ton of time.

  # Associations
    it { expect(user_response).to belong_to(:user) }
    it { expect(user_response).to belong_to(:content) }

    # Read-only matcher
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveReadonlyAttributeMatcher
    #it { expect(asset).to have_readonly_attribute(:uuid) }

    # Databse columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    #it { expect(user_response).to have_db_column(:political_stance).of_type(:string).with_options(default: 'undecided', null: false)}
    it { expect(user_response).to have_db_column(:content_id).of_type(:integer)}
    it { expect(user_response).to have_db_column(:user_id).of_type(:integer)}
    it { expect(user_response).to have_db_column(:response).of_type(:boolean)}
    
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord:have_db_index
  #it { expect(user_response).to have_db_index(:email).unique(:true)}
  #it { expect(user_response).to have_db_index(:user_responseid).unique(:true)}
  #it { expect(user_response).to have_db_index(:authentication_token).unique(:true)}
  end

  describe "public class methods" do
  #it { expect(user_response).to respond_to(:update_content_stat) }
  #it { expect(user_response).to respond_to(:reset_authentication_token!) }
  #it {expect(factory_instance.method_to_test).to eq(value_you_expect)

  end

end