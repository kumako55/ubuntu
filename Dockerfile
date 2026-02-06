FROM ubuntu:22.04

# Zaroori tools install karein
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    build-essential \
    cmake \
    libjson-c-dev \
    libwebsockets-dev \
    && rm -rf /var/lib/apt/lists/*

# TTYD install karne ka asaan tarika (Binary download)
RUN curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

ENV PORT=10000
EXPOSE 10000

# Terminal ko web par chalao
# -W ka matlab hai 'Writable' (aap command likh saken)
CMD ttyd -p $PORT -W bash
