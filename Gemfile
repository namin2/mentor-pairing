source "https://rubygems.org"

gem "compass-rails", "1.1.3"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "pg"
gem "rails", '4.0.13'
gem "sass-rails", '~>4.0.2'
gem "susy"
gem "uglifier"
gem  "gravtastic"

gem 'rails_12factor', group: :production
gem "watu_table_builder", :require => "table_builder", :git => "git://github.com/watu/table_builder.git"

group :development, :test do
  gem "capybara"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rake"
  gem "faker"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "coveralls", :require => false
end

group :production do
  gem 'therubyracer'
  gem 'newrelic_rpm'
end
