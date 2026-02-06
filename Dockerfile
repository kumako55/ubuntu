FROM alpine:3.18

ENV DISPLAY=:0
ENV PORT=10000

# Edge repositories add kar rahe hain takay novnc aur websockify mil sakein
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && apk add --no-cache \
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

# Startup script
CMD rm -f /tmp/.X0-lock && \
    Xvfb :0 -screen 0 800x600x16 & \
    sleep 2 && \
    openbox & \
    x11vnc -display :0 -forever -nopw -noxdamage -shared -rfbport 5900 & \
    sleep 2 && \
    netsurf & \
    websockify --web /usr/share/novnc/ $PORT localhost:5900
