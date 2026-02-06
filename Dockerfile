FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    openbox \
    xterm \
    firefox \
    xvfb \
    tigervnc-standalone-server \
    novnc websockify \
    dbus-x11 \
    ca-certificates \
    curl wget \
    && rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xauthority

EXPOSE 6080

CMD bash -c "\
Xvfb :0 -screen 0 1280x720x24 & \
export DISPLAY=:0 && \
openbox-session & \
vncserver :0 -localhost no -SecurityTypes None --I-KNOW-THIS-IS-INSECURE && \
websockify --web=/usr/share/novnc 6080 localhost:5900"
