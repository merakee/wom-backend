require 'rails_helper'

describe ContentCategory do

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:content_category) {ContentCategory.new}

  describe "ActiveModel validations" do

  # Basic validations
    it { expect(content_category).to validate_presence_of(:category)}
    
    it { expect(content_category).to allow_value("News","Secret","Rumor","LocalInfo","Other").for(:category) }
    it { expect(content_category).to_not allow_value("Random", "Fun").for(:category) }
  end

  describe "ActiveRecord associations" do

  # Associations
   it { expect(content_category).to have_many(:content).dependent(:destroy)}

    # Read-only matcher
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveReadonlyAttributeMatcher
    #it { expect(asset).to have_readonly_attribute(:uuid) }

    # Databse columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    #it { expect(content_category).to have_db_column(:political_stance).of_type(:string).with_options(default: 'undecided', null: false)}
    it { expect(content_category).to have_db_column(:category).of_type(:string)}

  # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord:have_db_index
  #it { expect(content_category).to have_db_index(:email).unique(:true)}
  #it { expect(content_category).to have_db_index(:content_categoryid).unique(:true)}
  #it { expect(content_category).to have_db_index(:authentication_token).unique(:true)}
  end

  describe "public class methods" do
  #it { expect(content_category).to respond_to(:update_content_stat) }
  #it { expect(content_category).to respond_to(:reset_authentication_token!) }
  #it {expect(factory_instance.method_to_test).to eq(value_you_expect)

  end

end