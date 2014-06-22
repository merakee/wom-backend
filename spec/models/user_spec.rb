describe User do
  let(:user) {FactoryGirl.create(:user)}

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
    expect(FactoryGirl.build(:user, email: "")).to_not be_valid
  end

  #it "should require an userid" do
  # expect(FactoryGirl.build(:user, userid: nil)).to_not be_valid
  #end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      expect(FactoryGirl.build(:user, email: address)).to be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      expect(FactoryGirl.build(:user, email: address)).to_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    FactoryGirl.create(:user)
    expect(FactoryGirl.build(:user)).to_not be_valid
  end

  it "should reject email addresses identical up to case" do
    expect(FactoryGirl.build(:user, email: user.email.upcase)).to_not be_valid
  end

  it "should have a password attribute" do
    expect(user.password).to be
  end

  #it "should have a password confirmation attribute" do
  # expect(user.password_confirmation).to be
  #end

  it "should require a password" do
    expect(FactoryGirl.build(:user, password: nil)).to_not be_valid
  end

  # it "should require a matching password confirmation" do
  #  User.new(@attr.merge(:password_confirmation => "invalid")).
  # should_not be_valid
  #end

  it "should reject short passwords" do
    expect(FactoryGirl.build(:user, password: "aaaaa")).to_not be_valid
  end

  it "should have an encrypted password attribute" do
    expect(user.encrypted_password).to be
  end

end