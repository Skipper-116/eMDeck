# Use Ruby 3.2 as the base image
FROM ruby:3.2.0

RUN mkdir /opt/EMR-API
# Set the working directory
WORKDIR /opt/EMR-API

# Install required system dependencies
RUN apt update && apt install -y \
    build-essential \
    libmariadb-dev-compat libmariadb-dev \
    git \
    default-mysql-client default-libmysqlclient-dev pv

# Copy the Gemfile from the host into the container
COPY ./tmp/Gemfile /opt/EMR-API/Gemfile

RUN bundle install

# Copy the application code from the tmp folder
COPY ./tmp/.git /opt/EMR-API/.git
COPY ./tmp/app /opt/EMR-API/app
COPY ./tmp/bin /opt/EMR-API/bin
COPY ./tmp/config /opt/EMR-API/config
COPY ./tmp/db /opt/EMR-API/db
COPY ./tmp/doc /opt/EMR-API/doc
COPY ./tmp/lib /opt/EMR-API/lib
COPY ./tmp/log /opt/EMR-API/log
COPY ./tmp/public /opt/EMR-API/public
COPY ./tmp/spec /opt/EMR-API/spec
COPY ./tmp/storage /opt/EMR-API/storage
COPY ./tmp/swagger /opt/EMR-API/swagger
COPY ./tmp/tmp /opt/EMR-API/tmp
COPY ./tmp/.rspec /opt/EMR-API/.rspec
COPY ./tmp/config.ru /opt/EMR-API/config.ru
COPY ./tmp/Rakefile /opt/EMR-API/Rakefile
# Remove this line once the active_support gem is updated to
COPY ./logger_thread_safe_level.rb /usr/local/bundle/gems/activesupport-7.0.8.7/lib/active_support/logger_thread_safe_level.rb


# Copy configuration files (excluding *.example files)
COPY ./config/ /opt/EMR-API/config/

# Precompile assets (if applicable)
# RUN bundle exec rake assets:precompile

# Expose the Rails server port
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
