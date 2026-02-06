FROM debian:bullseye-slim

# Minimal Environment
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV PORT=10000

# Sab kuch aik hi command mein install aur clean karein taake size minimal rahay
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    openbox \
    novnc \
    websockify \
    netsurf-gtk \
    xterm \
    ca-certificates \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# noVNC setup
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 10000

# Cleanup aur Minimal Startup
# 800x600 resolution 512MB RAM aur 0.1 vCPU ke liye perfect hai
CMD rm -f /tmp/.X0-lock && \
    Xvfb :0 -screen 0 800x600x16 & \
    sleep 2 && \
    openbox & \
    x11vnc -display :0 -forever -nopw -noxdamage -shared -rfbport 5900 & \
    sleep 2 && \
    netsurf-gtk & \
    websockify --web /usr/share/novnc/ $PORT localhost:5900
