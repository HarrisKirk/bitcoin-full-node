# Main image builder for blin 

FROM python:3
MAINTAINER Harris Kirk <cjtkirk@protonmail.com>

ENV PATH=.:$PATH
WORKDIR /opt/devops-bci
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install black

COPY . .
VOLUME /root/.ssh
