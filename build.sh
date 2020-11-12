#!/bin/bash
# Copyright (c) 2019-2020 Advanced Micro Devices, Inc. All rights reserved.

rocm_path=/opt/rocm
install_path=$PWD/install
configure_opts="--enable-rocm --with-rocm=$rocm_path"

./autogen.sh
./configure --prefix=$install_path $configure_opts
make -j install

