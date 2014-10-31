FROM ubuntu:14.04
MAINTAINER Joan Llopis <jllopisg@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LC_ALL es_ES.UTF-8
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/app/bin

ENV RUBY_VERSION 2.1.4
ENV PG_VERSION 9.3

# hopefully temporary work-around of http://git.io/Ke_Meg#1724
RUN apt-mark hold initscripts udev plymouth mountall

# System upgrade
RUN apt-get -qq update && \
    apt-get -qqy upgrade --no-install-recommends

# Install dependencies
RUN apt-get -qqy install python-software-properties git unzip imagemagick curl build-essential zlib1g-dev libreadline6-dev libyaml-dev libssl-dev libxslt-dev libxml2-dev --no-install-recommends

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get -qq update ; \
    apt-get -qqy install libpq-dev postgresql-client-$PG_VERSION --no-install-recommends

# Install ruby from source
ADD http://cache.ruby-lang.org/pub/ruby/2.1/ruby-$RUBY_VERSION.tar.gz /tmp/
WORKDIR /tmp
RUN tar zxvf ruby-$RUBY_VERSION.tar.gz && \
    cd ruby-$RUBY_VERSION && \
    ./configure --prefix=/usr --disable-install-doc --disable-install-rdoc && \
    make && make install && \
    cd .. && \
    rm -rf ruby-$RUBY_VERSION && rm ruby-$RUBY_VERSION.tar.gz

# Never install rdoc ri
RUN echo "gem: --no-ri --no-rdoc" > /etc/gemrc

WORKDIR /

# Install bundle
RUN gem install --no-rdoc --no-ri bundler -v 1.6.1
