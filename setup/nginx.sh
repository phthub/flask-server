#!/bin/bash

# Function to prompt user for input with default value
prompt() {
    local PROMPT_TEXT=$1
    local DEFAULT_VALUE=$2
    local USER_INPUT

    read -p "$PROMPT_TEXT [$DEFAULT_VALUE]: " USER_INPUT
    echo "${USER_INPUT:-$DEFAULT_VALUE}"
}

# Function to setup NGINX reverse proxy
setup_nginx_proxy() {
    SERVER_NAME=$(prompt "Enter the server name (e.g., example.com)" "example.com")
    PROXY_PASS=$(prompt "Enter the proxy pass URL (e.g., http://localhost:3000)" "http://localhost:3000")
    CONFIG_PATH=$(prompt "Enter the NGINX config file path" "/etc/nginx/sites-available/$SERVER_NAME")

    # Create the NGINX configuration
    cat <<EOL > $CONFIG_PATH
server {
    listen 80;
    server_name $SERVER_NAME;

    location / {
        proxy_pass $PROXY_PASS;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

    # Link configuration to sites-enabled
    ln -s $CONFIG_PATH /etc/nginx/sites-enabled/

    # Test NGINX configuration
    if nginx -t; then
        successlog "NGINX configuration is successful. Reloading NGINX."
        service restart nginx
    else
        errorlog "NGINX configuration test failed. Please check the configuration file for errors." && exit 1
    fi
}

# Main script
setup_nginx_proxy
