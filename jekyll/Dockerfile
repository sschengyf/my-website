FROM ruby:3.3-alpine3.22

# Add Jekyll dependencies
RUN apk add --no-cache \
    build-base \
    gcc \
    make \
    git

# Install Jekyll and Bundler
RUN gem install bundler jekyll

WORKDIR /usr/src/app

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Use the entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]
