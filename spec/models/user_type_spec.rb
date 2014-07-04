require 'rails_helper'

describe UserType do

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:user_type) {UserType.new}

  describe "ActiveModel validations" do

  # Basic validations
    it { expect(user_type).to validate_presence_of(:user_type)}
    
    it { expect(user_type).to allow_value("Anonymous", "Email", "Facebook", "Twitter", "GooglePlus","Others").for(:user_type) }
    it { expect(user_type).to_not allow_value("Random", "Guest").for(:user_type) }
  end

  describe "ActiveRecord associations" do

  # Associations
   it { expect(user_type).to have_many(:user).dependent(:destroy)}

    # Read-only matcher
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveReadonlyAttributeMatcher
    #it { expect(asset).to have_readonly_attribute(:uuid) }

    # Databse columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    #it { expect(user_type).to have_db_column(:political_stance).of_type(:string).with_options(default: 'undecided', null: false)}
    it { expect(user_type).to have_db_column(:user_type).of_type(:string)}

  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord:have_db_index
  #it { expect(user_type).to have_db_index(:email).unique(:true)}
  #it { expect(user_type).to have_db_index(:user_typeid).unique(:true)}
  #it { expect(user_type).to have_db_index(:authentication_token).unique(:true)}
  end

  describe "public class methods" do
  #it { expect(user_type).to respond_to(:update_content_stat) }
  #it { expect(user_type).to respond_to(:reset_authentication_token!) }
  #it {expect(factory_instance.method_to_test).to eq(value_you_expect)

  end

end