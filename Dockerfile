FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV PORT=10000

# Minimal installation (Sirf zaroori cheezein)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb x11vnc openbox novnc websockify xterm ca-certificates python3 \
    && rm -rf /var/lib/apt/lists/*

# noVNC setup
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 10000

# Cleanup, low resolution start, aur light window manager
CMD rm -f /tmp/.X0-lock && \
    Xvfb :0 -screen 0 800x600x16 & \
    sleep 3 && \
    openbox-session & \
    x11vnc -display :0 -forever -nopw -noxdamage -shared -rfbport 5900 & \
    websockify --web /usr/share/novnc/ $PORT localhost:5900
