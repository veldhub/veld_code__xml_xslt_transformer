FROM debian:bullseye-20250224-slim
RUN apt update
RUN apt install -y xsltproc=1.1.34*
RUN apt install -y curl=7.74.0*
WORKDIR /veld/executable/

