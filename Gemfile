source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'rails-api'

# Database
#gem 'sqlite3', '1.3.6'
gem 'pg', '0.12.2'

#Authentication
#gem 'devise'
gem 'bcrypt-ruby'

#Email validation
gem 'email-validator', '0.2.3'

# Project Management API wrappers
gem 'pivotal-tracker', '0.5.4'

# Testing tools
group :test, :development do
  gem 'rspec-rails', '2.10.1'
  gem 'capybara', '1.1.2'
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  gem 'guard-rspec', '0.5.5'
  gem 'factory_girl_rails', '3.5.0'
end

# linux specific gems
if RUBY_PLATFORM.downcase.include?('linux')
  gem 'libnotify', '0.5.9'
  gem 'rb-inotify', '0.8.8'
end

# mac specific gems
if RUBY_PLATFORM.downcase.include?('darwin')
  gem 'rb-fsevent', '0.9.1', :require => false
  gem 'growl', '1.0.3'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.4'
end

gem 'jquery-rails', '2.0.2'




# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
