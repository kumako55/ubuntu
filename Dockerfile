# Base image sirf 5MB ki
FROM alpine:3.18

# Environment variables
ENV DISPLAY=:0
ENV PORT=10000

# Alpine ke packages install karein (apk use hota hai apt ki jagah)
RUN apk add --no-cache \
    xvfb \
    x11vnc \
    openbox \
    novnc \
    websockify \
    netsurf \
    xterm \
    python3 \
    bash \
    && ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 10000

# Startup script (Alpine mein lock file ki location thodi alag hoti hai)
CMD rm -f /tmp/.X0-lock && \
    Xvfb :0 -screen 0 800x600x16 & \
    sleep 2 && \
    openbox & \
    x11vnc -display :0 -forever -nopw -noxdamage -shared -rfbport 5900 & \
    sleep 2 && \
    netsurf-gtk & \
    websockify --web /usr/share/novnc/ $PORT localhost:5900
