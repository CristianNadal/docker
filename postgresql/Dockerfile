FROM postgres:9.6

MAINTAINER Cristian Nadal "xtian.nadal@gmail.com"

ARG LOCALE=es_ES
ARG DB_NAME
ARG DB_USER
ARG DB_PASS

ENV LANG=${LOCALE}.utf8
ENV POSTGRES_DB=${DB_NAME}
ENV POSTGRES_USER=${DB_USER}
ENV POSTGRES_PASSWORD=${DB_PASS}

RUN localedef -i ${LOCALE} -c -f UTF-8 -A /usr/share/locale/locale.alias ${LOCALE}.UTF-8




