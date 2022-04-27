FROM elixir:1.13.4-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
WORKDIR /pot
COPY . .
RUN   apk update && \
      apk add --no-cache \
      openssh-keygen
RUN mkdir ssh && ssh-keygen -t rsa -b 1024 -f ssh/ssh_host_rsa_key
RUN mix compile
CMD ["mix", "run", "--no-halt"]
