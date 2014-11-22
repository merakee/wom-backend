require 'rails_helper'

describe Content do

  let(:user){build(:user)}

  it "has a valid factory" do
  # Using the shortened version of FactoryGirl syntax.
  # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb

    expect(build(:content, user: user)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:content) {build(:content, user: user)}

  describe "ActiveModel validations" do

  # Basic validations
    it { expect(content).to validate_presence_of(:user)}
    it { expect(content).to validate_presence_of(:content_category)}
    it { expect(content).to validate_presence_of(:text)}
    it { expect(content).to validate_uniqueness_of(:text).scoped_to([:user_id, :content_category_id]).with_message("User already has this content for the same category")}

    # Format validations
    it { expect(content).to allow_value("this").for(:text) }
    it { expect(content).to_not allow_value("").for(:text) }

  #it { expect(content).to allow_value(6).for(:content_type_id) }
  #it { expect(content).to_not allow_value(7).for(:content_type_id) }
  #it { expect(content).to_not allow_value(0).for(:content_type_id) }

  # Inclusion/acceptance of values
  #it { expect(tumblog).to ensure_inclusion_of(:status).in_array(['draft', 'public', 'queue']) }
  #it { expect(tng_group).to ensure_inclusion_of(:age).in_range(18..35) }
  #it { expect(band).to ensure_length_of(:bio).is_at_least(25).is_at_most(1000) }
  #it { expect(tweet).to ensure_length_of(:content).is_at_most(140) }
  #it { expect(applicant).to ensure_length_of(:ssn).is_equal_to(9) }
  #it { expect(contract).to validate_acceptance_of(:terms) }  # For boolean values
  #it { expect(content).to validate_confirmation_of(:password) }  # Ensure two values match
  end

  describe "ActiveRecord associations" do
  # http://guides.rubyonrails.org/association_basics.html
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames
  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord

  # Performance tip: stub out as many on create methods as you can when you're testing validations
  # since the test suite will slow down due to having to run them all for each validation check.
  #
  # For example, assume a content has three methods that fire after one is created, stub them like this:
  #
  # before(:each) do
  #   content.any_instance.stub(:send_welcome_email)
  #   content.any_instance.stub(:track_new_content_signup)
  #   content.any_instance.stub(:method_that_takes_ten_seconds_to_complete)
  # end
  #
  # If you performed 5-10 validation checks against a content, that would save a ton of time.

  # Associations
    it { expect(content).to belong_to(:content_category) }
    it { expect(content).to belong_to(:user) }
    it { expect(content).to have_many(:user_response).dependent(:destroy)  }

    # Read-only matcher
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveReadonlyAttributeMatcher
    #it { expect(asset).to have_readonly_attribute(:uuid) }

    # Databse columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    #it { expect(content).to have_db_column(:political_stance).of_type(:string).with_options(default: 'undecided', null: false)}
    it { expect(content).to have_db_column(:text).of_type(:text)}
    it { expect(content).to have_db_column(:photo_token).of_type(:string)}
    it { expect(content).to have_db_column(:content_category_id).of_type(:integer)}
    it { expect(content).to have_db_column(:user_id).of_type(:integer)}
    it { expect(content).to have_db_column(:total_spread).of_type(:integer)}
    it { expect(content).to have_db_column(:kill_count).of_type(:integer)}
    it { expect(content).to have_db_column(:spread_count).of_type(:integer)}
    #it { expect(content).to have_db_column(:no_response_count).of_type(:integer)}
    it { expect(content).to have_db_column(:comment_count).of_type(:integer)}
    it { expect(content).to have_db_column(:new_comment_count).of_type(:integer)}
    it { expect(content).to have_db_column(:flag_count).of_type(:integer)}

  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord:have_db_index
  #it { expect(content).to have_db_index(:email).unique(:true)}
  #it { expect(content).to have_db_index(:contentid).unique(:true)}
  #it { expect(content).to have_db_index(:authentication_token).unique(:true)}
  end

  describe "public class methods" do
  #it { expect(content).to respond_to(:ensure_authentication_token!) }
  #it { expect(content).to respond_to(:reset_authentication_token!) }
  #it {expect(factory_instance.method_to_test).to eq(value_you_expect)

  end

end