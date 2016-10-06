# A sample Gemfile
source "https://rubygems.org"

# gem "rails"

gem 'rake'
gem 'activerecord'
gem 'activesupport'
gem 'monetize'

gem 'test-unit'
gem 'rspec'

gem 'sqlite3'

gem 'mongoid'

gem 'simplecov'

# Windowsでは動かない
# gem 'stackprof'

# ruby2.3にした時にDevKitを入れろといわれた。面倒なのでとりあえず外しておく。
# gem 'ruby-prof'

gem 'memory_profiler'

group :test do
  if RUBY_PLATFORM =~ /(win32|w32)/
    gem "win32console", '1.3.0'
  end
  gem "minitest"
  gem 'minitest-reporters', '>= 0.5.0'
  gem 'cucumber-rails'
  # gem 'fuzzbert'
  gem 'mrproper'
end