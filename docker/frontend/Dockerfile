# Stage 1: Build the Ionic Vue application
FROM node:20 AS builder

# Set the working directory
WORKDIR /app

# Copy the application code from the tmp folder
COPY ./tmp/ .

# Copy configuration files (excluding *.example files)
COPY ./config/ /app/config/
RUN find /app/config/ -type f -name "*.example" -delete

# Install dependencies and build the application
RUN npm install
RUN npm run build

# Stage 2: Serve the built application using Nginx
FROM nginx:stable

# Copy built files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose the Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
