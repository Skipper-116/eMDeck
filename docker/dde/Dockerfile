# Use Ruby 3.2 as the base image
FROM ruby:3.2.0

RUN mkdir /opt/DDE
# Set the working directory
WORKDIR /opt/DDE

# Install required system dependencies
RUN apt update && apt install -y \
    build-essential \
    libmariadb-dev-compat libmariadb-dev \
    default-mysql-client default-libmysqlclient-dev pv

COPY tmp/Gemfile /opt/DDE/Gemfile
COPY tmp/vendor /opt/DDE/vendor

RUN bundle install

# Copy the application code from the tmp folder
COPY ./tmp/ /opt/DDE

# Copy configuration files (excluding *.example files)
COPY ./config/ /opt/DDE/config/

# Precompile assets (if applicable)
# RUN bundle exec rake assets:precompile

# Expose the Rails server port
EXPOSE 3001

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
