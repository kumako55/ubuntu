# 1️⃣ Base image
FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 2️⃣ Install core packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 xfce4-terminal xterm \
    tigervnc-standalone-server \
    novnc websockify \
    sudo curl wget git vim tzdata \
    dbus-x11 x11-utils x11-xserver-utils x11-apps \
    firefox \
    xubuntu-icon-theme \
    python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 3️⃣ Install Python packages (Gradio + Playwright)
RUN pip3 install --no-cache-dir gradio playwright
RUN playwright install chromium

# 4️⃣ Setup Xauthority
RUN touch /root/.Xauthority

# 5️⃣ noVNC setup
RUN mkdir -p /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# 6️⃣ Expose ports
EXPOSE 5901  # VNC
EXPOSE 6080  # noVNC

# 7️⃣ Start VNC + noVNC
CMD bash -c "\
vncserver :1 \
  -localhost no \
  -SecurityTypes None \
  -geometry 1024x768 \
  --I-KNOW-THIS-IS-INSECURE && \
openssl req -new -x509 -days 365 -nodes -subj '/C=JP' \
  -out /root/self.pem -keyout /root/self.pem && \
websockify -D --web=/usr/share/novnc/ \
  --cert=/root/self.pem 6080 localhost:5901 && \
tail -f /dev/null"
