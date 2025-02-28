# Organizer

This script is an educational project designed to replicate the functionality and interface of commonly used tools like **ffuf, gobuster, dnsrecon**, etc.  

Its main goal is to mimic the experience of using command-line flags to execute operations, running the script globally, and providing a structured approach similar to well-known tools.  

While not particularly useful for advanced tasks, it can serve as an example of script development or be used for quick file organization with minimal customization.

## Features

Currently supports:

- Organizing files based on **extension**
- Deleting files older than a specific **number of days**

## Installation

```bash
# Clone the repository
git clone https://github.com/rGharco/organizer.git
cd organizer

# Move the script to a system-wide location
mv organizer.sh /usr/local/bin

# Ensure the script is executable
chmod +x /usr/local/bin/organizer.sh

# Add an alias for easier use (temporary)
alias organizer='/usr/local/bin/organizer.sh'

# To make the alias permanent, add it to your shell config
echo "alias organizer='/usr/local/bin/organizer.sh'" >> ~/.bashrc
source ~/.bashrc  # Apply changes (for Bash users)
