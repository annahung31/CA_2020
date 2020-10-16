FROM ubuntu:latest

# Copy hw2
COPY Examples /root/Examples
COPY Problems /root/Problems

ENV DEBIAN_FRONTEND="noninteractive"

# Update system and install packages
RUN apt-get update
RUN apt-get install -yq tmux wget vim git autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev libncurses-dev libncurses5-dev

# risc-v toolchain
RUN wget -q https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz && \
    tar -xvzf riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz && \
    rm riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz
RUN mv riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14 /opt/riscv

# rebuilt gdb for tui
RUN wget ftp://ftp.gnu.org/gnu/gdb/gdb-8.3.1.tar.xz && \
    tar xvf gdb-8.3.1.tar.xz && rm gdb-8.3.1.tar.xz
RUN cd gdb-8.3.1 && ./configure --program-prefix=riscv64-unknown-elf- -with-tui --target=riscv64-linux-gnu --prefix=/opt/riscv && make -j4 && make install
RUN rm -rf /gdb-8.3.1

ENV PATH=$PATH:/opt/riscv/bin

# riscv-pk (proxy kernel)
RUN wget -q https://github.com/riscv/riscv-pk/archive/v1.0.0.tar.gz && \
    tar -xvzf v1.0.0.tar.gz && rm v1.0.0.tar.gz
RUN cd riscv-pk-1.0.0 && mkdir build && cd build && \
    ../configure --prefix=/opt/riscv --host=riscv64-unknown-elf && \
    make -j4 && make install
RUN rm -rf /riscv-pk-1.0.0

# Spike ISA Simulator
RUN wget -q https://github.com/riscv/riscv-isa-sim/archive/v1.0.0.tar.gz && \
    tar -xvzf v1.0.0.tar.gz && rm v1.0.0.tar.gz
RUN cd riscv-isa-sim-1.0.0 && mkdir build && cd build && \
    ../configure --prefix=/opt/riscv --enable-histogram && \
    make -j4 && make install
RUN rm -rf /riscv-isa-sim-1.0.0

# OpenOCD
RUN git clone https://github.com/riscv/riscv-openocd.git
RUN cd riscv-openocd && ./bootstrap && mkdir build && cd build && \
    ../configure --prefix=/opt/riscv --enable-remote-bitbang --enable-jtag_vpi --disable-werrormake && \
    make -j4 && make install
RUN rm -rf /riscv-openocd

RUN echo "export PATH=$PATH:/opt/riscv/bin" >> ~/.bashrc

# Cleanup
RUN apt-get autoremove -y && apt-get autoclean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*
