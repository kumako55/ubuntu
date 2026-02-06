FROM debian:bullseye-slim

# Zaroori packages
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Naya aur updated Gotty download karein
RUN curl -sSL https://github.com/s0rg/gotty/releases/download/v1.5.0/gotty_linux_amd64.tar.gz | tar xz -C /usr/local/bin

# Permissions set karein
RUN chmod +x /usr/local/bin/gotty

# Render Port
ENV PORT=10000
EXPOSE 10000

# Important: --permit-write (-w) aur --port lazmi hain
# Hum bash ko direct call kar rahe hain
CMD ["gotty", "--address", "0.0.0.0", "--port", "10000", "--permit-write", "bash"]
