# FROM nvidia/cuda:latest ubuntu LTS
FROM nvcr.io/nvidia/cuda:11.8.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt upgrade -y
RUN apt install wget -y

# just creating the doc dir for fahclient and moving supplied config.xml there as a "sample"
RUN mkdir -p /usr/share/doc/fahclient/
ADD config.xml /usr/share/doc/fahclient/sample-config.xml

# Download/Install latest FAH client
# See here for latest - https://foldingathome.org/alternative-downloads/
RUN wget https://download.foldingathome.org/releases/beta/fah-client/debian-stable-64bit/release/latest.deb
&& \
  dpkg -i --force-depends latest.deb && \
  rm latest.deb && \
  apt-get autoremove -y && \
  apt install ocl-icd-opencl-dev -y

# EXPOSE 7396 36396

ADD config.xml /etc/fahclient/config.xml

WORKDIR /var/lib/fahclient
CMD	["/usr/bin/FAHClient", \
	"--config", "/etc/fahclient/config.xml", \
	"--config-rotate=false", \
	"--gpu=true", \
	# "--run-as", "fahclient", \
	"--pid-file=/var/run/fahclient.pid"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
