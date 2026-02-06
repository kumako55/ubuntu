FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV VNC_PORT=5900
ENV NOVNC_PORT=10000

# Install components (added python3-pip for websockify)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    python3 \
    xterm \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Fix the noVNC pathing for Ubuntu 22.04
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 10000

# Using 'sh -c' to ensure multiple background processes run correctly
CMD sh -c "Xvfb :0 -screen 0 1280x720x16 & \
    fluxbox & \
    x11vnc -display :0 -forever -nopw -listen localhost -rfbport $VNC_PORT & \
    websockify --web /usr/share/novnc/ $NOVNC_PORT localhost:$VNC_PORT"
