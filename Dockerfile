# flutter docker image version from https://github.com/cirruslabs/docker-images-flutter/pkgs/container/flutter : *stable* version (no 'pre' or 'beta')
FROM ghcr.io/cirruslabs/flutter:3.27.2

# Conf
## Google Cloud CLI filename + hash from https://cloud.google.com/sdk/docs/downloads-versioned-archives (Linux 64-bit (x86_64) version)
ENV GCLOUD_TGZ="google-cloud-cli-linux-x86_64.tar.gz"
ENV GCLOUD_TGZ_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_TGZ}"
ENV GCLOUD_TGZ_HASH="382bff10fca6f72570d138a9903c3e49ad3a1eb488d5494356051136e3906a71"

## --- END OF VARIABLES TO CHANGE FOR UPDATE ---

# Download (if necessary) & install GCloud CLI
RUN mkdir /google-cloud-cli
WORKDIR "/google-cloud-cli"
RUN curl -O "${GCLOUD_TGZ_URL}"
RUN echo "${GCLOUD_TGZ_HASH}  ${GCLOUD_TGZ}" | shasum -a 256 -c - # the double space is required
RUN tar -xzf "${GCLOUD_TGZ}"
RUN ./google-cloud-sdk/install.sh --quiet # --quiet to avoid interactive prompts
ENV PATH="${PATH}:/google-cloud-cli/bin"

# Install deps for ffigen
RUN apt-get update -y
RUN apt-get install -y llvm libclang-dev

# cleanup
RUN rm -rf /var/lib/apt/lists/*
RUN rm "/google-cloud-cli/${GCLOUD_TGZ}"

WORKDIR "/"
