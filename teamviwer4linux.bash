#!/bin/bash

# Define configuration variables
supporterhost="linuxepert.ddnsservice.blah"  # Change this to your actual supporter host
supporteremail="linuxepert@domain.blah"  # Change this to your actual supporter email
supporterport=22  # the port your ssh server runs on
supporterreverseport=2022  # the port you use to open the reverse connection
supporteruser="guest" # the user with which you allow the supportee to log onto your machine
supporter_id_pub="" # your public ssh key


# Function to install openssh-server if not installed
install_ssh_server() {
    if ! dpkg -s openssh-server >/dev/null 2>&1; then
        echo "openssh-server not installed. Installing now..."
        sudo apt-get update && sudo apt-get install -y openssh-server
        echo "openssh-server installed successfully."
    else
        echo "openssh-server is already installed."
    fi
}

# Function to check and generate SSH key if not exists
check_generate_ssh_key() {
    if [ ! -f ~/.ssh/id_rsa.pub ]; then
        echo "SSH key does not exist. Generating now..."
        ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
        echo "SSH key generated successfully."
    else
        echo "SSH key already exists."
    fi
}

# Function to compose email with Thunderbird, sending you their public ssh key
compose_email() {
    local publicsshkeypath="$HOME/.ssh/id_rsa.pub"
    echo "Composing email to $supporteremail with attachment."
    thunderbird -compose "subject=Linux support,to='$supporteremail',attachment='$publicsshkeypath',body='user: $USER'"
    echo "Email composed. Press any key to continue after your supporter has processed the SSH key..."
    read -n 1 -s
}

# Function to open SSH connection with short timeout
open_ssh() {
    # this assumes their ssh server runs on port 22 (which it will if this script just installed it)
    if ! ssh -o ConnectTimeout=2 -X -f -N -R $supporterreverseport:localhost:22 -p $supporterport $supporteruser@$supporterhost; then
        echo "SSH connection failed."
        return 1
    fi
    echo "SSH connection established."
    return 0
}

add_ssh_key_if_missing() {
    local keyfile="$HOME/.ssh/authorized_keys"

    # Check if the authorized_keys file exists, create if not
    [ -f "$keyfile" ] || touch "$keyfile"

    # Check if the key is already in the file
    if ! grep -Fq "$supporter_id_pub" "$keyfile"; then
        echo "Adding key to authorized_keys..."
        echo "$supporter_id_pub" >> "$keyfile"
    else
        echo "Key is already in authorized_keys."
    fi
}


function set_sshd_conf() {
  local option="$1"
  local value="$2"
  local file="/etc/ssh/sshd_config"

  # Check if the option is already set to the desired value
  if ! grep -E "^\s*$option\s+$value" "$file" >/dev/null; then
    # Use sudo to update the configuration and reload sshd
    sudo sed -i "/^#\?$option / s/^.*$/$option $value/" "$file"
    sudo systemctl reload sshd
  fi
}

# Main function to orchestrate steps
main() {
    echo "Starting support setup..."
    install_ssh_server
    set_sshd_conf PasswordAuthentication no
    set_sshd_conf PubkeyAuthentication yes
    set_sshd_conf X11Forwarding yes
    check_generate_ssh_key
    # Add your SSH public key to their authorized keys, so you don't need to know their password
    add_ssh_key_if_missing
    if open_ssh; then
        echo "Connection successful."
    else
        echo "Attempting to resolve connection issue..."
        compose_email
        echo "Retrying SSH connection..."
        open_ssh
    fi
}

main
