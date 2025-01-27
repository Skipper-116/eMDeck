# Use Ruby 3.2 as the base image
FROM ruby:3.2.0

RUN mkdir /opt/EMR-API
# Set the working directory
WORKDIR /opt/EMR-API

# Install required system dependencies
RUN apt update && apt install -y \
    build-essential \
    libmariadb-dev-compat libmariadb-dev \
    default-mysql-client default-libmysqlclient-dev pv

COPY Gemfile /tmp/Gemfile
COPY tmp/Gemfile /opt/EMR-API/Gemfile
COPY tmp/vendor /opt/EMR-API/vendor

RUN bundle install

# Copy the application code from the tmp folder
COPY ./tmp/ /opt/EMR-API

# Copy configuration files (excluding *.example files)
COPY ./config/ /opt/EMR-API/config/

# Precompile assets (if applicable)
# RUN bundle exec rake assets:precompile

# Expose the Rails server port
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
