# Lightweight Ubuntu 22.04
FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu
ENV PASSWORD=ubuntu

# 1️⃣ Install core GUI packages + VNC + noVNC
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 xfce4-terminal xterm \
    tigervnc-standalone-server \
    novnc websockify \
    sudo curl wget git vim tzdata \
    dbus-x11 x11-utils x11-xserver-utils x11-apps \
    firefox \
    xubuntu-icon-theme \
    && rm -rf /var/lib/apt/lists/*

# 2️⃣ Setup Xauthority
RUN touch /root/.Xauthority

# 3️⃣ Setup noVNC directory
RUN mkdir -p /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# 4️⃣ Expose ports
EXPOSE 5901
EXPOSE 6080

# 5️⃣ Start VNC + noVNC in one command (HF / Render friendly)
CMD bash -c "\
Xvfb :1 -screen 0 1024x768x24 & \
export DISPLAY=:1 && \
vncserver :1 -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
openssl req -new -x509 -days 365 -nodes -subj '/C=JP' \
  -out /root/self.pem -keyout /root/self.pem && \
websockify --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901"
