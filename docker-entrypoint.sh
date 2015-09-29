#!/bin/bash
git clone --depth 1 https://github.com/raosungang/rails101s.git app
cd app
source ~/.bash_profile
bundle install
bundle exec rake db:migrate
if [ $? != 0 ]; then
     echo
     echo "== Failed to migrate. Runing setup first."
     echo
     bundle exec rake db:setup && \
     bundle exec rake db:migrate
  fi
export SECRET_KEY_BASE=$(rake secret)
bundle exec rails server -b 0.0.0.0
