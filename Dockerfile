FROM ubuntu:22.04

# Zaroori tools install karein
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# TTYD Binary download (Direct download without tar complexity)
# Hum 1.7.3 version use kar rahe hain jo sabse stable hai
RUN curl -L https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 -o /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd

# Render environment variables
ENV PORT=10000
EXPOSE 10000

# --writable ka matlab hai aap commands likh saken
# --port 10000 Render ke default port ke liye
CMD ["ttyd", "-p", "10000", "-W", "bash"]
