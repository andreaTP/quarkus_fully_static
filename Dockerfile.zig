FROM maven:3.8.5-jdk-11 AS build-image

ARG GRAAL_VERSION="22.1.0"
ARG ZIG_VERSION="0.10.0-dev.2351+b64a1d5ab"

COPY . /build

RUN apt update && apt install -y wget xz-utils zlib1g-dev

RUN wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-java11-linux-amd64-${GRAAL_VERSION}.tar.gz && \
    tar -xvf graalvm-ce-java11-linux-amd64-${GRAAL_VERSION}.tar.gz && \
    wget https://ziglang.org/builds/zig-linux-x86_64-${ZIG_VERSION}.tar.xz && \
    tar -xvf zig-linux-x86_64-${ZIG_VERSION}.tar.xz

ENV PATH="/graalvm-ce-java11-${GRAAL_VERSION}/bin:/zig-linux-x86_64-${ZIG_VERSION}:${PATH}"

RUN gu install native-image

WORKDIR /build

RUN mvn clean package -Pnative -Dquarkus.native.additional-build-args="--static","--libc=musl","-H:CLibraryPath=/usr/lib/x86_64-linux-gnu","--native-compiler-path=/build/zigcc","--native-compiler-options=-target x86_64-linux-musl"

FROM scratch

COPY --from=build-image /build/target/code-with-quarkus-1.0.0-SNAPSHOT-runner /

ENTRYPOINT [ "/code-with-quarkus-1.0.0-SNAPSHOT-runner" ]
