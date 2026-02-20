ARG FEDORA_VERSION=${FEDORA_VERSION}

FROM scratch AS ctx
COPY build-scripts /
COPY patches /patches
COPY system-files/assets /assets
COPY system-files/ /system-files

FROM quay.io/fedora/fedora-bootc:${FEDORA_VERSION}
COPY system-files/common /

ARG FLAVOR=${FLAVOR}

RUN mkdir -p /usr/lib/bootupd/updates \
    && cp -r /usr/lib/efi/*/*/* /usr/lib/bootupd/updates

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint
