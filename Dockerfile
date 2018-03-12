FROM postgres:10
RUN apt-get update &&\
    apt-get install make -yqq &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
