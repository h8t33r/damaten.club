source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 5.2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'pg', '~> 0.18.4' # locum postgresql 9.4

# gem 'bundler', '~>1.16.3'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'materialize-sass', '~> 1.0.0.rc2'
#gem 'jquery-rails', '~> 4.3'

gem 'unicorn', '~> 5.1.0'

gem 'devise', '~> 4.2'

# for activejob
#gem 'sidekiq', '~> 5.0', '>= 5.0.5'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem "capistrano", "~> 3.11", require: false
  gem "capistrano-bundler", '~> 1.3.0', require: false
  gem "capistrano-rvm", require: false
  gem 'capistrano-rails', require: false
end

group :test do
  #gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end
