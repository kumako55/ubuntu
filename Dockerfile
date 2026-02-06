# Lightweight Ubuntu + amd64
FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1️⃣ Core dependencies
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

# 3️⃣ Expose VNC and noVNC ports
EXPOSE 5901
EXPOSE 6080

# 4️⃣ Start VNC + noVNC in one CMD
CMD bash -c "\
vncserver :1 -localhost no -SecurityTypes None -geometry 1024x768 && \
openssl req -new -x509 -days 365 -nodes -subj '/C=JP' -out /root/self.pem -keyout /root/self.pem && \
websockify -D --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901 && \
tail -f /dev/null"
