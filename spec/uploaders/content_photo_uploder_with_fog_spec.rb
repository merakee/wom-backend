require 'carrierwave/test/matchers'

include CarrierWave::Test::Matchers

describe ContentPhotoUploader do

  before do
    ContentPhotoUploader.enable_processing = true
  end
  after do
    ContentPhotoUploader.enable_processing = false
  end

  let(:user){create(:user)}
  let(:content){build(:content, user: user)}

  describe "upload sucess " do

    it "file should be there" do
      content.save
      expect(content.photo_token).not_to be_nil
      expect(content.photo_token.file).to exist
      expect(content.photo_token.file.url).to include("wombackend-dev-freelogue")
    end

    it "should thubm image to be no bigger than 120 by 120 pixels" do
      expect(content.photo_token.thumb).not_to be_nil
      expect(content.photo_token.thumb.file).to exist
      expect(content.photo_token.thumb).to be_no_taller_than(120)
      expect(content.photo_token.thumb).to be_no_wider_than(120)
    end

  end

end