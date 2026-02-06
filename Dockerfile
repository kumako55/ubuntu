FROM ubuntu:22.04

# Minimal Environment
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV PORT=10000

# Sab kuch ek hi layer mein install karenge aur faltu files delete kar denge
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb x11vnc openbox websockify novnc netsurf-gtk xterm python3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# noVNC link fix
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 10000

# Startup script: Pehle purani locks saaf karein, phir screen chota rakhein (RAM ke liye)
CMD rm -f /tmp/.X0-lock && \
    Xvfb :0 -screen 0 800x600x16 & \
    sleep 2 && \
    openbox & \
    x11vnc -display :0 -forever -nopw -noxdamage -shared -rfbport 5900 & \
    sleep 1 && \
    netsurf-gtk & \
    websockify --web /usr/share/novnc/ $PORT localhost:5900
