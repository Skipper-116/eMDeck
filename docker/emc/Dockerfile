# Stage 1: Build the Ionic Vue application
FROM node:20 AS builder

RUN mkdir /opt/EMC
# Set the working directory
WORKDIR /opt/EMC

# Copy the application code from the tmp folder
COPY ./tmp/ .

# Copy configuration files (excluding *.example files)
# COPY ./config/ /opt/EMC/config/

# Install dependencies and build the application
RUN npm install --legacy-peer-deps
RUN npm install -g @ionic/cli@latest
RUN npm install -g @vue/cli@latest
RUN ionic build

# Stage 2: Serve the built application using Nginx
FROM nginx:stable

# Copy built files from the builder stage
COPY --from=builder /opt/EMC/dist /usr/share/nginx/html

# Expose the Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
