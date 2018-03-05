FROM library/alpine:3.6
MAINTAINER spli@dundee.ac.uk

RUN apk add --update curl && \
    rm /var/cache/apk/*

ARG KUBE_VERSION=1.9.3
ARG HELM_VERSION=2.7.2
RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zxvf - linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rmdir linux-amd64 && \
    chmod +x /usr/local/bin/kubectl /usr/local/bin/helm

RUN adduser -D kube
USER kube
RUN helm init --client-only
