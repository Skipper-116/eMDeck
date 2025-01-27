# Use Ruby 3.2 as the base image
FROM ruby:3.2

# Set the working directory
WORKDIR /app

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the application code from the tmp folder
COPY ./tmp/ .

# Copy configuration files (excluding *.example files)
COPY ./config/ /app/config/
RUN find /app/config/ -type f -name "*.example" -delete

# Install Ruby dependencies
RUN bundle install

# Precompile assets (if applicable)
RUN bundle exec rake assets:precompile

# Expose the Rails server port
EXPOSE 3001

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
