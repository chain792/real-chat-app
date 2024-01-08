# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /myapp

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libpq-dev postgresql-client libvips

# Install JavaScript dependencies
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle config --local path vendor/bundle
RUN bundle install

# # Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# # Copy application code
# COPY . .

# # Final stage for app image
# FROM base

# # Install packages needed for deployment
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y curl libvips postgresql-client && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# # Copy built artifacts: gems, application
# COPY --from=build /chat-app /chat-app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["./bin/dev"]
