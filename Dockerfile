# Base image
FROM ubuntu:22.04

# Non-interactive mode taake installation ke waqt sawal na puche
ENV DEBIAN_FRONTEND=noninteractive

# 1. Zaroori tools, VNC, noVNC, Fluxbox aur Firefox install karein
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    firefox \
    xterm \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. noVNC setup (vnc.html ko index.html banana taake direct access ho sake)
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Environment variables
ENV DISPLAY=:0
ENV PORT=10000

# Render ka port expose karein
EXPOSE 10000

# 3. Startup script: Xvfb, Fluxbox, VNC aur Firefox ko ek saath chalane ke liye
CMD sh -c "Xvfb :0 -screen 0 1280x720x16 & \
    fluxbox & \
    x11vnc -display :0 -forever -nopw -listen localhost -rfbport 5900 & \
    /usr/bin/python3 /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen $PORT"
