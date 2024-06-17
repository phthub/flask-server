#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install a package if not already installed
install_package() {
    local PACKAGE=$1
    if ! dpkg -l | grep -qw "$PACKAGE"; then
        warnlog "$PACKAGE is not installed. Installing $PACKAGE..."
        apt install -y "$PACKAGE" &> /dev/null
        if dpkg -l | grep -qw "$PACKAGE"; then
            successlog "$PACKAGE installed successfully."
        else
            errorlog "Failed to install $PACKAGE. Please install it manually and run this script again."
            exit 1
        fi
    else
        infolog "$PACKAGE is already installed."
    fi
}

# Function to check and install dependencies
check_and_install_dependencies() {
    infolog "Updating repos..."
    apt update
    infolog "Checking and installing dependencies..."
    local DEPENDENCIES=("python3" "python3-flask" "wget" "net-tools" "openssh-client" "wget" "curl" "python3-pip")
    for PACKAGE in "${DEPENDENCIES[@]}"; do
        install_package "$PACKAGE"
    done
}

# Main script
check_and_install_dependencies
