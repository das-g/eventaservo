FROM ruby:2.7-buster

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y \
  locales \ 
  postgresql-client \
  postgresql-server-dev-all \
  nodejs \
  nano \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && locale-gen en_US.UTF-8

RUN gem install bundler
RUN npm install -g yarn

WORKDIR /eventaservo

RUN bundle config set --local without 'development'
RUN bundle config set --local without 'test'
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 2 --retry 3

COPY yarn.lock ./
RUN yarn
COPY . .

# Executa toda vez que o container inicia
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Inicia do Rails Server
CMD ["bundle", "exec", "rails", "server", "-b", "ssl://0.0.0.0:3000?key=/eventaservo/certs/private.key&cert=/eventaservo/certs/certificate.crt"]
