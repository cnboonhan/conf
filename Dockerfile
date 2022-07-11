FROM ubuntu:latest

RUN apt update && apt install wget python3 sudo -y
RUN wget https://raw.githubusercontent.com/cnboonhan/conf/main/bootstrap.py && python3 bootstrap.py

WORKDIR /root/.conf
#RUN . .venv/bin/activate && \
  #pip3 install awslambdaric

RUN . .venv/bin/activate && \
  pip3 install -r requirements.txt

# Add installation commands here
RUN . .venv/bin/activate && \
  python3 -m scripts.installation.webdriver.install-webdriver

RUN . .venv/bin/activate && \
  python3 -m scripts.installation.webdriver.install-chrome
