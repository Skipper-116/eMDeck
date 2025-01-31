# Use Ruby 3.2 as the base image
FROM ruby:3.2.0

RUN mkdir /opt/DDE
RUN mkdir /opt/DDE/log
RUN touch /opt/DDE/log/development.log
RUN touch /opt/DDE/log/test.log
RUN touch /opt/DDE/log/production.log
# Set the working directory
WORKDIR /opt/DDE

# Install required system dependencies
RUN apt update && apt install -y \
    build-essential \
    git \
    libmariadb-dev-compat libmariadb-dev \
    default-mysql-client default-libmysqlclient-dev pv

COPY tmp/Gemfile /opt/DDE/Gemfile

RUN bundle install

# Copy the application code from the tmp folder
COPY ./tmp/.git /opt/EMR-API/.git
COPY ./tmp/app /opt/DDE/app
COPY ./tmp/bin /opt/DDE/bin
COPY ./tmp/config /opt/DDE/config
COPY ./tmp/db /opt/DDE/db
COPY ./tmp/lib /opt/DDE/lib
COPY ./tmp/public /opt/DDE/public
COPY ./tmp/spec /opt/DDE/spec
COPY ./tmp/swagger /opt/DDE/swagger
COPY ./tmp/storage /opt/DDE/storage
COPY ./tmp/tmp /opt/DDE/tmp
COPY ./tmp/test /opt/DDE/test
COPY ./tmp/config.ru /opt/DDE/config.ru
COPY ./tmp/Rakefile /opt/DDE/Rakefile
# Remove this line once the active_support gem is updated to
COPY ./logger_thread_safe_level.rb /usr/local/bundle/gems/activesupport-7.0.8.7/lib/active_support/logger_thread_safe_level.rb


# Copy configuration files (excluding *.example files)
COPY ./config/ /opt/DDE/config/

# Precompile assets (if applicable)
# RUN bundle exec rake assets:precompile

# Expose the Rails server port
EXPOSE 3001

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
