FROM python:3.10.0-alpine
MAINTAINER sascha.schwarz1@kyndyl.com

ENV PYTHONUNBUFFERED 1

RUN apk add --no-cache --virtual .pynacl_deps build-base python3-dev libffi-dev

RUN python -m pip install --upgrade pip

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY ./ansible_requirements.yml /ansible_requirements.yml
RUN  ansible-galaxy install -r ansible_requirements.yml

RUN mkdir /collector_app
WORKDIR /collector_app
COPY ./collector_app /collector_app

RUN adduser -D user
USER user
