# Start from the code-server Debian base image
FROM codercom/code-server:3.9.3 

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install stuff u want
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN sudo apt-get install python3-pip
RUN curl https://rclone.org/install.sh | sudo bash
RUN git clone https://github.com/bnsave100/DLscripts.git
RUN git clone https://github.com/Amenly/EroMe.git
RUN pip install requests
RUN pip3 install erome
RUN python3 -m pip install --upgrade yt-dlp -y

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
