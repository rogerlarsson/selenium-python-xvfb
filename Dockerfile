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

ARG GECKODRIVER_VERSION=latest
RUN GK_VERSION=$(if [ ${GECKODRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- "https://api.github.com/repos/mozilla/geckodriver/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([0-9.]+)".*/\1/'); else echo $GECKODRIVER_VERSION; fi) \
  && echo "Using GeckoDriver version: "$GK_VERSION \
  && wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GK_VERSION/geckodriver-v$GK_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GK_VERSION \
  && chmod 755 /opt/geckodriver-$GK_VERSION \
  && ln -fs /opt/geckodriver-$GK_VERSION /usr/bin/geckodriver
  
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