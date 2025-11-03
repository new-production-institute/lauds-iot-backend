# Use lightweight Nginx image to serve static files
FROM nginx:alpine

# Copy all frontend assets into Nginx’s default public directory
COPY . /usr/share/nginx/html

# Expose port 80 (mapped to host later)
EXPOSE 80
