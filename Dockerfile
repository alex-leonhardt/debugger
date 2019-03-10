FROM ubuntu:bionic

RUN sed -E -i 's:^(deb.*main)$:\1 non-free:ig' /etc/apt/sources.list
RUN apt-get update && apt-get -y install ca-certificates 
RUN apt-get update && apt-get -y install lsb-release apt-utils gnupg2 && \
    apt-get -y install git vim curl net-tools iputils-ping apt-transport-https ca-certificates gnupg2 software-properties-common python-pip python-dev  arping iperf netperf ethtool cmake linux-base linux-tools-common linux-tools-$(uname -r) linux-cloud-tools-$(uname -r) linux-tools-generic linux-cloud-tools-generic dnsutils strace
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4052245BD4284CDD && \
    echo "deb https://repo.iovisor.org/apt/$(lsb_release -cs) $(lsb_release -cs) main" > /etc/apt/sources.list.d/iovisor.list
RUN apt-get update && apt-get -y install bcc-tools libbcc-examples linux-headers-$(uname -r)
RUN mkdir -p /opt/tools \
    && cd /opt/tools \
    && git clone https://github.com/alex-leonhardt/FlameGraph.git \
    && echo "PATH=\$PATH:/opt/tools/FlameGraph:/usr/share/bcc/tools:." >> /root/.bahsrc

WORKDIR /opt/tools
ENV PATH $PATH:/opt/tools/FlameGraph:/usr/share/bcc/tools:.
CMD ["/bin/bash"]
