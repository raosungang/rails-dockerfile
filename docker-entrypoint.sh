#!/bin/bash
git clone --depth 1 https://github.com/raosungang/demo_app.git app
cd app
bundle install
rake db:migrate
if [ $? != 0 ]; then
     echo
     echo "== Failed to migrate. Runing setup first."
     echo
     rake db:setup && \
     rake db:migrate
  fi
 rails server
