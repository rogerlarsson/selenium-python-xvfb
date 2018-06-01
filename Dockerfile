FROM ubuntu:18.04

ENV BROWSER firefox
ENV DISPLAY :99

RUN apt-get update && apt-get install -y python3-pip python3-dev \
        && cd /usr/local/bin \
        && ln -s /usr/bin/python3 python 

RUN apt-get update && apt-get install -y $BROWSER \
        build-essential libssl-dev \ 
        xvfb xz-utils zlib1g-dev \
        nano wget curl

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install selenium pyvirtualdisplay requests unittest-xml-reporting \
                ipdb

ADD libs/xvfb_init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
ADD libs/xvfb-daemon-run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run

RUN mkdir -vp /app
WORKDIR /app
CMD bash