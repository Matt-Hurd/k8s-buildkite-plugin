FROM mexisme/jsonnet:alpine AS jsonnet

FROM google/cloud-sdk:alpine AS gcloud

FROM buildkite/agent:3.15.0

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash ca-certificates coreutils curl git jq libstdc++ openssh

ENV K8S_VERSION="v1.15.4"
RUN curl -sfL https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

COPY --from=jsonnet /jsonnet /usr/local/bin/jsonnet

COPY --from=gcloud /google-cloud-sdk /google-cloud-sdk

ENV PATH="/google-cloud-sdk/bin:${PATH}"

ENTRYPOINT [ "/entrypoint.sh"]
