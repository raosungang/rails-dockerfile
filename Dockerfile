FROM ubuntu:utopic
MAINTAINER Skycn <raosungang@hotmail.com>

# Just use bash.
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Debian complains about the terminal environment on docker.use this.
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selectinos

# Change sources
RUN  sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup
ADD ./sources.list /etc/apt/sources.list

# Install base packages
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl wget ca-certificates build-essential autoconf python-software-properties libyaml-dev

RUN apt-get install -y gawk g++ libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev mysql-client postgresql-client 
# Finish installing remaining dependencies
RUN apt-get install -y libssl-dev libmysqlclient-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev bison openssl make git libpq-dev libsqlite3-dev nodejs && apt-get clean
RUN rm -rf /var/cache/apt/* /tmp/*


#RUN wget http://nginx.org/keys/nginx_signing.key && \
#  sudo apt-key add nginx_signing.key  && \
#  deb http://nginx.org/packages/ubuntu/ utopic nginx && \
#  deb-src http://nginx.org/packages/ubuntu/ utopic nginx
# RUN apt-get update && \
#  apt-get install nginx

# Force sudoers to not being asked the password
RUN echo %sudo    ALL=NOPASSWD: ALL >> /etc/sudoers

# Add a user just for runing the app
RUN useradd -m -G sudo app

USER app
WORKDIR /home/app

# rvm install
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \ 
  curl -sSL https://get.rvm.io | bash -s stable 
# ruby install
RUN /bin/bash -l -c "rvm requirements && rvm install 2.2.2 && rvm use 2.2.2 --default"
# Change rubygems sources
RUN /bin/bash -l -c "gem sources -a https://ruby.taobao.org/ && gem sources --remove https://rubygems.org/"

# install bundeler
RUN /bin/bash -l -c "gem sources -l"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN rm -rf /home/app/.rvm/src/*

ADD docker-entrypoint.sh /home/app/docker-entrypoint.sh
RUN sudo chmod +x /home/app/docker-entrypoint.sh
ADD setup.sh /home/app/setup.sh
ENV RAILS_ENV=prodcution

EXPOSE 3000:3000

ENTRYPOINT  /home/app/docker-entrypoint.sh
# docker run -t 
