FROM library/golang:1.10.0 as builder

#RUN git clone https://github.com/roboll/helmfile.git /go/src/github.com/roboll/helmfile && \
#    cd /go/src/github.com/roboll/helmfile && \
#    git reset --hard 283848c594aaed03512f3badaf4f66e8d49c4532
RUN git clone --branch zap-logger --depth 1 https://github.com/manics/helmfile.git /go/src/github.com/roboll/helmfile
# Commit e1405f9c2cba5e544ea05100bb6554c63e911d08
RUN cd /go/src/github.com/roboll/helmfile && \
    go build

######################################################################
FROM library/alpine:3.6
MAINTAINER spli@dundee.ac.uk

RUN apk add --update curl && \
    rm /var/cache/apk/*

# kubectl has good backwards compatibility, helm doesn't
ARG KUBE_VERSION=1.10.4
ARG HELM_VERSION=2.9.1
ARG HELMDIFF_VERSION=2.9.0+2
RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zxvf - linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rmdir linux-amd64 && \
    chmod +x /usr/local/bin/*

COPY --from=builder /go/src/github.com/roboll/helmfile/helmfile /usr/local/bin/

RUN adduser -D kube
USER kube
WORKDIR /home/kube
RUN helm init --client-only

RUN curl -sSL https://github.com/databus23/helm-diff/releases/download/v${HELMDIFF_VERSION}/helm-diff-linux.tgz | \
    tar -C /home/kube/.helm/plugins -xz
