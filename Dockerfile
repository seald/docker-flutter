# flutter docker image version from https://github.com/cirruslabs/docker-images-flutter/pkgs/container/flutter : *stable* version (no 'pre' or 'beta')
FROM ghcr.io/cirruslabs/flutter:3.27.2

# Conf
## Google Cloud CLI filename + hash from https://cloud.google.com/sdk/docs/downloads-versioned-archives (Linux 64-bit (x86_64) version)
## BUT now using the versioned file, which has the same content with a different hash. To get the hash just DL the file and compute it.
ENV GCLOUD_TGZ="google-cloud-cli-508.0.0-linux-x86_64.tar.gz"
ENV GCLOUD_TGZ_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_TGZ}"
ENV GCLOUD_TGZ_HASH="ec7ed30d8f9c5b14ae126c08c2d18779b5823087995c7b521fcf70fd26ddf97d"

## --- END OF VARIABLES TO CHANGE FOR UPDATE ---

# Download (if necessary) & install GCloud CLI
WORKDIR "/"
RUN curl -O "${GCLOUD_TGZ_URL}"
RUN echo "${GCLOUD_TGZ_HASH}  ${GCLOUD_TGZ}" | shasum -a 256 -c - # the double space is required
RUN tar -xzf "${GCLOUD_TGZ}"
RUN /google-cloud-sdk/install.sh --quiet # --quiet to avoid interactive prompts
ENV PATH="${PATH}:/google-cloud-sdk/bin"

# Install deps for ffigen
RUN apt-get update -y
RUN apt-get install -y llvm libclang-dev

# cleanup
RUN rm -rf /var/lib/apt/lists/*
RUN rm "/${GCLOUD_TGZ}"

WORKDIR "/"
