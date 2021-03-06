FROM fluencelabs/fluence

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    pkg-config \
    libssl-dev \
    git \
    vim

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup install nightly && rustup target add wasm32-wasi

# Install the Aqua compiler and standard library 
RUN npm -g install @fluencelabs/aqua && npm -g install @fluencelabs/aqua-lib

RUN cargo install marine && cargo +nightly install mrepl