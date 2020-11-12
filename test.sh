#!/bin/bash
# Copyright (c) 2019-2020 Advanced Micro Devices, Inc. All rights reserved.

set -x
for verb in read write send
do
    for bench in lat bw
    do
        exe="ib_$verb""_$bench"
        sleep 1
        ./$exe -a -F -d mlx5_0 --use_rocm &
        sleep 1
        ./$exe localhost -a -F -d mlx5_0 --use_rocm
        wait
    done
done
