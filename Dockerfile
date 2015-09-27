FROM ubuntu:utopic
MAINTAINER Skycn <raosungang@hotmail.com>

# Just use bash.
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Debian complains about the terminal environment on docker.use this.
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selectinos

# Install base packages
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl wget ca-certificates build-essential autoconf python-software-properties libyaml-dev

RUN apt-get install -y gawk g++ libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev
# Finish installing remaining dependencies
RUN apt-get install -y libssl-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev bison openssl make git libpq-dev libsqlite3-dev nodejs
RUN apt-get clean
RUN rm -rf /var/cache/apt/* /tmp/*
# Force sudoers to not being asked the password
RUN echo %sudo    ALL=NOPASSWD: ALL >> /etc/sudoers

# Add a user just for runing the app
RUN useradd -m -G sudo app

USER app
WORKDIR /home/app

# rvm install
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \curl -sSL https://get.rvm.io | bash -s stable 


RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.2"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
#ENTRYPOINT source '/home/app/.rvm/scripts/rvm'
RUN source /home/app/.rvm/scripts/rvm
# source ~/.rvm/scripts/rvm

# Install a ruby version
#RUN /home/app/.rvm/bin/rvm  install 2.2.2 && /bin/sh --login && /home/app/.rvm/bin/rvm use 2.2.2 --default && /home/app/.rvm/rubies/ruby-2.2.2/bin/gem install rails -v 4.2.4 -V --no-ri --no-rdoc
#RUN rm -rf /home/app/.rvm/src/*

#ADD install-rails.sh /home/app/install-rails.sh
#ENTRYPOINT /home/app/install-rails.sh

#ADD docker-entrypoint.sh /home/app/docker-entrypoint.sh
#ADD setup.sh /home/app/setup.sh
#RUN /bin/sh --login
#RUN /home/app/.rvm/bin/rvm use 2.2.2 --default 
#RUN /home/app/.rvm/rubies/ruby-2.2.2/bin/gem install rails -v 4.2.4 -V --no-ri --no-rdoc
ENV RAILS_ENV=prodcution

EXPOSE 3000:3000


#ENTRYPOINT /home/app/docker-entrypoint.sh
# docker run -t 
