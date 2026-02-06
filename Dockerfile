FROM ubuntu:22.04

# Zaroori tools aur python setup
RUN apt-get update && apt-get install -y curl bash python3 python3-pip && \
    curl -L https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz | tar xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/gotty

# Render ka port
ENV PORT=10000
EXPOSE 10000

# Fix: --address 0.0.0.0 lazmi hai taake Render bahar se connect kar sakay
CMD gotty -w -p $PORT --address 0.0.0.0 bash
