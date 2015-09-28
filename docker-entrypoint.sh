git clone --depth 1 https://github.com/raosungang/demo_app.git app
cd app
if [ -f /home/app/.rvm/scripts/rvm ];then
   /home/app/.rvm/scripts/rvm
fi

/bin/bash -l -c 'bundle install'
/bin/bash -l -c 'rake db:migrate' 
if [ $? != 0 ]; then
     echo
     echo "== Failed to migrate. Runing setup first."
     echo
    /bin/bash -l -c 'rake db:setup && rake db:migrate'
  fi
 /bin/bash -l -c ' rails server'
