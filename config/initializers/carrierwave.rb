if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  # make sure our uploader is auto-loaded
  ContentPhotoUploader

  # use different dirs when testing
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/spec/testfiles/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/spec/testfiles/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end

else 
  # for development and production user S3
  CarrierWave.configure do |config|
    config.storage = :fog 
    config.enable_processing = true
  end
end

# fog set up
#Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
fog_dir = Rails.env == 'production' ? (ENV['S3_BUCKET_NAME'] || 'wombackend-freelogue' ): 'wombackend-dev-freelogue'
CarrierWave.configure do |config|
  config.fog_credentials = {:provider => 'AWS',
    :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key => ENV['AWS_SECRET_KEY']}
  config.fog_directory  = fog_dir
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end