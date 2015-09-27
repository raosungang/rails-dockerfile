git clone --depth 1 https://github.com/raosungang/rails101s.git app

cd app

bundle install

bundle exec rake db:create 
  if [[ $? !=0 ]]; then
     echo
     echo "== Failed to migrate. Runing setup first."
     echo
     bundle exec rake db:setup && \
     bundle exec rake db:migrate
  fi
bundle exec rails server




