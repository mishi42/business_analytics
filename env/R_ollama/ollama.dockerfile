FROM ollama/ollama
USER root
EXPOSE 11434

ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# 日本語フォントのインストール 
RUN apt-get update && \
    apt-get install -y \
    sudo openssh-client curl wget iputils-ping
    # texlive-full

RUN ollama serve & \
    until curl -s http://localhost:11434/api/tags >/dev/null; do sleep 1; done && \
    ollama pull gemma3:1b && \
    ollama pull deepseek-coder-v2:16b && \
    ollama pull gemma3:4b && \
    snowflake-arctic-embed2:568m && \
    pkill ollama

