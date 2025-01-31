FROM nginx:stable

# Create the directory for the application
RUN mkdir /opt/CORE

# Set the working directory
WORKDIR /opt/CORE

# Copy the application code from the tmp folder
COPY ./tmp/ /usr/share/nginx/html

# Copy configuration files (excluding *.example files)
COPY ./config/ /opt/CORE

# Expose the Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]