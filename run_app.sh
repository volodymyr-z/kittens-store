bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rspec
bundle exec rackup -d --port 1234 --host '0.0.0.0'
