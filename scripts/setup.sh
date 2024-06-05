#Add execute permissions
chmod +x bx-*.sh

# Install the latest .jar files and all of the modules
bx-install.sh

# Run the cli
bx-cli.sh

# Run a webserver from your current directory
bx-web.sh