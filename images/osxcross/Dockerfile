FROM rust:slim-bookworm
RUN apt-get update && apt-get install -y \
  clang \
  llvm-dev \
  libxml2-dev \
  uuid-dev \
  libssl-dev \
  bash \
  patch \
  make \
  tar \
  xz-utils \
  bzip2 \
  gzip \
  git \
  curl \
  cmake \
  python3 \
  cpio \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /opt
RUN git clone https://github.com/tpoechtrager/osxcross
COPY MacOSX14.4.sdk.tar.xz /opt/osxcross/tarballs/
WORKDIR /opt/osxcross
RUN UNATTENDED=yes ./build.sh
ENV PATH="/opt/osxcross/target/bin:${PATH}"
RUN mkdir -p ~/.cargo
RUN echo '[target.x86_64-apple-darwin]\n\
  linker = "x86_64-apple-darwin20.4-clang"\n\
  ar = "x86_64-apple-darwin20.4-ar"\n\
  \n\
  [target.aarch64-apple-darwin]\n\
  linker = "aarch64-apple-darwin20.4-clang"\n\
  ar = "aarch64-apple-darwin20.4-ar"' > ~/.cargo/config.toml
RUN rustup target add x86_64-apple-darwin aarch64-apple-darwin
ENV CC_x86_64_apple_darwin=x86_64-apple-darwin20.4-clang
ENV CXX_x86_64_apple_darwin=x86_64-apple-darwin20.4-clang++
ENV AR_x86_64_apple_darwin=x86_64-apple-darwin20.4-ar
ENV CC_aarch64_apple_darwin=aarch64-apple-darwin20.4-clang
ENV CXX_aarch64_apple_darwin=aarch64-apple-darwin20.4-clang++
ENV AR_aarch64_apple_darwin=aarch64-apple-darwin20.4-ar
WORKDIR /app
