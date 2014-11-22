require 'rails_helper'

describe CommentResponse do
  let(:user){create(:user)}
  let(:comment) {create(:comment, user: user)}

  it "has a valid factory" do
  # Using the shortened version of FactoryGirl syntax.
  # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:comment_response, user: user, comment: comment)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:comment_response) {create(:comment_response, user: user, comment: comment)}

  describe "ActiveModel validations" do

  # Basic validations
    it { expect(comment_response).to validate_presence_of(:user)}
    #it { expect(comment_response).to validate_presence_of(:response)}
    it { expect(comment_response).to validate_presence_of(:comment)}

    # Format validations
    it { expect(comment_response).to allow_value(true).for(:response) }
    it { expect(comment_response).to allow_value(false).for(:response) }
    it { expect(comment_response).not_to allow_value(nil).for(:response) }
    it { expect(comment_response).to validate_uniqueness_of(:user_id).scoped_to([:comment_id]).with_message("User already liked this comment. User cannot like same comment more than once.")}


  #it { expect(comment_response).to_not allow_value("1er").for(:response) }

  #it { expect(comment_response).to allow_value(6).for(:comment_response_type_id) }
  #it { expect(comment_response).to_not allow_value(7).for(:comment_response_type_id) }
  #it { expect(comment_response).to_not allow_value(0).for(:comment_response_type_id) }

  # Inclusion/acceptance of values
  #it { expect(tumblog).to ensure_inclusion_of(:status).in_array(['draft', 'public', 'queue']) }
  #it { expect(tng_group).to ensure_inclusion_of(:age).in_range(18..35) }
  #it { expect(band).to ensure_length_of(:bio).is_at_least(25).is_at_most(1000) }
  #it { expect(tweet).to ensure_length_of(:comment_response).is_at_most(140) }
  #it { expect(applicant).to ensure_length_of(:ssn).is_equal_to(9) }
  #it { expect(contract).to validate_acceptance_of(:terms) }  # For boolean values
  #it { expect(comment_response).to validate_confirmation_of(:password) }  # Ensure two values match
  end

  describe "ActiveRecord associations" do
  # http://guides.rubyonrails.org/association_basics.html
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord

  # Performance tip: stub out as many on create methods as you can when you're testing validations
  # since the test suite will slow down due to having to run them all for each validation check.
  #
  # For example, assume a comment_response has three methods that fire after one is created, stub them like this:
  #
  # before(:each) do
  #   comment_response.any_instance.stub(:send_welcome_email)
  #   comment_response.any_instance.stub(:track_new_comment_response_signup)
  #   comment_response.any_instance.stub(:method_that_takes_ten_seconds_to_complete)
  # end
  #
  # If you performed 5-10 validation checks against a comment_response, that would save a ton of time.

  # Associations
    it { expect(comment_response).to belong_to(:user) }
    it { expect(comment_response).to belong_to(:comment) }

    # Read-only matcher
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveReadonlyAttributeMatcher
    #it { expect(asset).to have_readonly_attribute(:uuid) }

    # Databse columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    #it { expect(comment_response).to have_db_column(:political_stance).of_type(:string).with_options(default: 'undecided', null: false)}
    it { expect(comment_response).to have_db_column(:comment_id).of_type(:integer)}
    it { expect(comment_response).to have_db_column(:user_id).of_type(:integer)}
    it { expect(comment_response).to have_db_column(:response).of_type(:boolean)}
    
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord:have_db_index
  #it { expect(comment_response).to have_db_index(:email).unique(:true)}
  #it { expect(comment_response).to have_db_index(:comment_responseid).unique(:true)}
  #it { expect(comment_response).to have_db_index(:authentication_token).unique(:true)}
  end

  describe "public class methods" do
  #it { expect(comment_response).to respond_to(:update_comment_stat) }
  #it { expect(comment_response).to respond_to(:reset_authentication_token!) }
  #it {expect(factory_instance.method_to_test).to eq(value_you_expect)

  end

end