FROM node:20 AS builder

RUN mkdir /opt/CORE
# Set the working directory
WORKDIR /opt/CORE

# Copy the application code from the tmp folder
COPY ./tmp/ .

# Copy configuration files (excluding *.example files)
COPY ./config/ /opt/CORE

FROM nginx:stable

# Copy built files from the builder stage
COPY --from=builder /opt/CORE/ /usr/share/nginx/html

# Expose the Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]