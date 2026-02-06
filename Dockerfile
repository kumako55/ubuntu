# 1️⃣ Base image
FROM ubuntu:22.04

# 2️⃣ Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu
ENV PASSWORD=ubuntu

# 3️⃣ Install core packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    sudo \
    vim \
    net-tools \
    python3 \
    python3-pip \
    xfce4 \
    xfce4-terminal \
    x11vnc \
    xvfb \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# 4️⃣ Install noVNC (browser-based VNC client)
RUN mkdir -p /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# 5️⃣ Python packages (optional, for Playwright / Gradio)
RUN pip3 install --no-cache-dir gradio playwright

# 6️⃣ Install Chromium for Playwright
RUN playwright install chromium

# 7️⃣ Supervisor config for VNC + noVNC
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 8️⃣ Expose ports
EXPOSE 5900   # VNC
EXPOSE 6080   # noVNC web GUI

# 9️⃣ Start supervisor
CMD ["/usr/bin/supervisord", "-n"]
