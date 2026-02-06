FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget curl sudo vim net-tools python3 python3-pip xfce4 xfce4-terminal \
    x11vnc xvfb supervisor \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

RUN pip3 install --no-cache-dir gradio playwright
RUN playwright install chromium

EXPOSE 5900
EXPOSE 6080

CMD ["/usr/bin/supervisord", "-n"]
