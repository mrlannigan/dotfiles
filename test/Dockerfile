FROM debian:testing
MAINTAINER Julian Lannigan <julian.lannigan@gmail.com>

RUN apt-get update
RUN apt-get install --quiet -y git python python-pip

RUN python -m pip install --quiet green
RUN git clone --recursive https://github.com/mrlannigan/dotfiles /root/.dotfiles
RUN /root/.dotfiles/dot install

ADD . /root/.dotfiles/test
WORKDIR /root/.dotfiles/test
CMD green test
