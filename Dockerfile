FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Firefox + noVNC + websockify
RUN apt-get update && apt-get install -y --no-install-recommends \
    firefox \
    tigervnc-standalone-server \
    novnc websockify \
    dbus-x11 \
    ca-certificates \
    curl wget git \
    && rm -rf /var/lib/apt/lists/*

# Setup noVNC
RUN mkdir -p /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Expose Hugging Face mapped port
EXPOSE 6080

# Use HF X server (:0) and start websockify for browser access
CMD bash -c "\
export DISPLAY=:0 && \
# Start Firefox in normal GUI mode on HF display \
firefox & \
# Expose HF display via noVNC \
websockify --web=/usr/share/novnc 6080 localhost:5900"
