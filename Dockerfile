FROM library/alpine:3.7
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN apk add --no-cache curl

# kubectl has good backwards compatibility, helm doesn't
ARG KUBE_VERSION=1.12.5
ARG HELM_VERSION=2.12.2
ARG HELMFILE_VERSION=0.41.0
ARG HELMDIFF_VERSION=2.11.0+3
RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zxvf - linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rmdir linux-amd64 && \
    curl -sL https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 -o /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/*

RUN adduser -D kube
USER kube
WORKDIR /home/kube
RUN helm init --client-only

RUN curl -sSL https://github.com/databus23/helm-diff/releases/download/v${HELMDIFF_VERSION}/helm-diff-linux.tgz | \
    tar -C /home/kube/.helm/plugins -xz
