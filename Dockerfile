FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    firefox \
    xterm \
    ca-certificates \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Fix noVNC paths (Ubuntu 22.04 placement)
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Environment variables
ENV DISPLAY=:0
ENV PORT=10000

EXPOSE 10000

# Startup script with Cleanup and Direct Websockify call
CMD rm -f /tmp/.X0-lock && \
    Xvfb :0 -screen 0 1280x720x16 & \
    sleep 2 && \
    fluxbox & \
    x11vnc -display :0 -forever -nopw -listen localhost -rfbport 5900 & \
    websockify --web /usr/share/novnc/ $PORT localhost:5900
