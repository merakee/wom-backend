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

# data store
gem 'redis'

# Background and scheduled jobs
gem 'whenever', :require => false
gem 'sidekiq'
# If sidekig monitoring is needed
gem 'sinatra',  :require => nil


# uploading and processing photos
gem 'fog' , '1.24', require: "fog/aws/storage" # require to Optimized Loading of Fog. must be before carrierwave gem
gem 'carrierwave'
gem 'mini_magick'

# foreign key support
gem 'foreigner'
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

# Development
group :development, :test do
  # server thin
  gem 'thin'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rails-erd'
  gem 'spring' # preloader to seep up development process
  gem 'request-log-analyzer' # for analyzing log data on local machine 
  gem 'yard'

end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  # DB diagram
  gem 'database_cleaner'
end