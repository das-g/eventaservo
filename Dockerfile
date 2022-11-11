FROM ruby:2.7-bullseye

WORKDIR /app

# NodeJS PPA Repository
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get update && apt-get install -y \
  g++ \
  gcc \
  iputils-ping \
  libmagick++-dev \
  libssl-dev \
  make \
  nodejs \
  poppler-utils \
  postgresql-server-dev-all \
  telnet \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

ARG AMBIENTE=production
# Sets environment variables
ENV RAILS_ENV=${AMBIENTE}
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV GOOGLE_MAPS_KEY=${GOOGLE_MAPS_KEY}
ENV IPINFO_KEY=${IPINFO_KEY}

# Bundler
RUN gem install bundler:2.1.4
RUN if [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then \
  bundle config set without development test && \
  bundle config set deployment true && \
  bundle config set frozen true ; fi

COPY Gemfile Gemfile.lock ./
RUN bundle install --retry=3

# YARN
RUN npm install -g yarn
RUN yarn set version 3.2.1
COPY .yarnrc.yml ./
COPY package.json yarn.lock ./
RUN yarn install

COPY . .

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
RUN if [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then \
  bundle exec rails assets:precompile ; \
  fi

# Kreas API dokumentadon ĉe /public/docs/api/v2/
RUN if [ "$RAILS_ENV" = "production" ]; then \
  npm install -g redoc-cli && \
  mkdir -p public/docs/api/v2/ && \
  redoc-cli build openapi/v2.yaml -o public/docs/api/v2/index.html ; \
  fi

EXPOSE 3000

ENTRYPOINT [ "./entrypoint.sh" ]
