FROM debian:bullseye-slim
RUN apt update
RUN apt install -y xsltproc=1.1.34-4+deb11u1
RUN apt install -y less
RUN useradd -u 1000 docker_user
USER docker_user
