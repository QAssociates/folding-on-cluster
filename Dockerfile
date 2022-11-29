# FROM nvidia/cuda:latest ubuntu LTS
FROM nvcr.io/nvidia/cuda:11.8.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive


RUN apt update && apt upgrade -y
RUN apt install wget -y

RUN apt -y install systemctl

# just creating the doc dir for fahclient and moving supplied config.xml there as a "sample"
RUN mkdir -p /usr/share/doc/fahclient/
ADD config.xml /usr/share/doc/fahclient/sample-config.xml

# Download/Install latest FAH client
# See here for latest - https://foldingathome.org/alternative-downloads/
RUN mkdir fah-client && cd fah-client && \ 
wget https://download.foldingathome.org/releases/beta/fah-client/debian-stable-64bit/release/latest.deb && \
  dpkg-deb --extract latest.deb . && \
  cp usr/bin/fah-client /usr/bin/fah-client && \
  cd .. && rm -rf fah-client && \
  apt-get autoremove -y && \
  apt install ocl-icd-opencl-dev -y

# EXPOSE 7396 36396

ADD config.xml /etc/fahclient/config.xml

WORKDIR /var/lib/fahclient
CMD	["/usr/bin/fah-client", \
	"--config", "/etc/fahclient/config.xml"]
