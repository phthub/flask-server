#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" &> /dev/null
}

execute_command() {
  local command="$1"
  echo "Executing: $command"
  eval "$command"
}

terminal() {
    while true; do
        echo -e "Type 'exit' to exit."
        read -e -p "(flask-server)> " user_command
        # Check if the user wants to exit
        if [[ "$user_command" == "exit" ]]; then
            echo "Exiting command runner."
            break
        fi
        execute_command "$user_command"
    done
}

# Function to install a package if not already installed
install_package() {
    local PACKAGE=$1
    apt install -y "$PACKAGE" &> /dev/null
    while true; do
        if ! dpkg -l | grep -qw "$PACKAGE"; then
            errorlog "Failed to install $PACKAGE. Please install it manually."
            terminal
        else
            break
        fi
    done
}

# Function to check and install dependencies
check_and_install_dependencies() {
    infolog "Updating repos..."
    apt update &> /dev/null
    infolog "Checking and installing dependencies..."
    local DEPENDENCIES=("python3" "python3-flask" "wget" "net-tools" "openssh-client" "curl" "python3-pip" "nginx")
    for PACKAGE in "${DEPENDENCIES[@]}"; do
        install_package "$PACKAGE"
    done
}

# Main script
check_and_install_dependencies
