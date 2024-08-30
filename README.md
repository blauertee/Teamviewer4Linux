Teamviewer4Linux
-----
A simple scripts that allows you to give technical support to you friends whom you've convinced to use Linux.


Usage
-----

### Prerequisites

-   Use this only with close friends relatives or other people you trust fully
-   Ensure you have `openssh-server` and `Thunderbird` installed on your system.
-   The supporter must provide their public SSH key to be used by the script.

### Steps to Run the Script

1.  **Edit the Configuration:** Modify the script to include the correct supporter details such as hostname (`supporterhost`), email (`supporteremail`), ports (`supporterport` and `supporterreverseport`), and user (`supporteruser`).

2.  **Execute the Script:** Explain to the supportee how to run the script from the terminal

3.  **Connect to their Machine**: `ssh -p supporterreverseport supportee-username@localhost`
