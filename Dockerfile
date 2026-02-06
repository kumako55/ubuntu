FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl bash python3 pip && \
    curl -L https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz | tar xz -C /usr/local/bin

ENV PORT=10000
EXPOSE 10000

CMD gotty -w -p $PORT bash
