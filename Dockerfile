# Main image builder for blin 

FROM python:3.10.5
MAINTAINER Harris Kirk <cjtkirk@protonmail.com>

ENV PATH=.:$PATH
WORKDIR /opt/devops-bci
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt --upgrade
RUN pip install black

COPY . .
VOLUME /root/.ssh

CMD  ["/bin/bash", "-c", "bci --install-completion 1> /dev/null; /bin/bash"]


