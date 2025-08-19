#use nginx to make a static server
FROM nginx:alpine

# Copy all files from root directory
COPY . /usr/share/nginx/html

# Remove files we don't want in the container
RUN rm -rf /usr/share/nginx/html/terraform \
    && rm -rf /usr/share/nginx/html/docker \
    && rm -rf /usr/share/nginx/html/.github \
    && rm -f /usr/share/nginx/html/.gitignore \
    && rm -f /usr/share/nginx/html/README.md

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
