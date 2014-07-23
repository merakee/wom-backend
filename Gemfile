source 'https://rubygems.org'

gem 'rails', '4.1.1'

# api gem
gem 'rails-api'

# database
#gem 'sqlite3', :group => [:development, :test]
gem 'pg' #, :group => :production

# authetication
gem 'warden'
gem 'devise'

# uploading and processing photos
gem 'fog', require: "fog/aws/storage" # require to Optimized Loading of Fog. must be before carrierwave gem
gem 'carrierwave'
gem 'mini_magick'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# To use Jbuilder templates for JSON
# gem 'jbuilder'



# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Testing
gem 'spring', :group => :development  # preloader to seep up development process

group :development, :test do
  # server thin
  gem 'thin'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rails-erd'
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  # DB diagram
  gem 'database_cleaner'
  #gem 'fakefs' 
end