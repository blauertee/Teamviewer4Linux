Teamviewer4Linux
-----
A simple scripts that allows you to give technical support to your friends and family whom you've convinced to use Linux (without them having to expose their machine to the internet.)

Description
-----

This script does the following:
 - install openssh server on your supportees machine (if not installed)
 - generate an ssh-key on your supportees machine (if not already generated)
 - add your public ssh_key to their authorized_keys (if not already in there)
 - try to open a reverse shell to your machine
 - on failure compose a thunderbird message sending your their public ssh key (they have to click send manually)
 - wait for any key
 - retry opening the reverse ssh shell

Usage
-----

### Prerequisites

-   Use this only with close friends relatives or other people you trust fully
-   Your machine is accessible via SSH + Key authentification from the internet

### Steps to Run the Script

1.  **Edit the Configuration:** Modify the script to include the correct supporter details such as hostname (`supporterhost`), email (`supporteremail`), ports (`supporterport` and `supporterreverseport`), and user (`supporteruser`).

2.  **Execute the Script:** Explain to the supportee how to run the script from the terminal

3.  **Connect to their Machine**: `ssh -p supporterreverseport supportee-username@localhost`
