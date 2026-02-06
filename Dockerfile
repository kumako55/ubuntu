# Use a slim Ubuntu base for lightweight footprint
FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal GUI components, VNC server, and noVNC
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    xterm \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set up noVNC: Link vnc.html to index.html for easier access
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Set display environment variable
ENV DISPLAY=:0
ENV VNC_PORT=5900
ENV NOVNC_PORT=10000

# Expose Render's default port
EXPOSE 10000

# Start script to run Xvfb, Fluxbox, VNC, and noVNC
CMD Xvfb :0 -screen 0 1280x720x16 & \
    fluxbox & \
    x11vnc -display :0 -forever -nopw -listen localhost -rfbport $VNC_PORT & \
    /usr/share/novnc/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NOVNC_PORT
