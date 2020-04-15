#!/bin/bash

# Run all latency and bandwidth benchmarks
# Launch script on server first, then on client
# On server: $ ./run_all.sh
# On client: $ ./run_all.sh <server ip>

server=$1
gen_opts='-a -F -d mlx5_0'
d2d_opts='--use_rocm'
inl_opts='-I 0'
bw_opts='--report_gbits'

for verb in send write read
do
    for bench in lat bw
    do
        exe=ib_"$verb"_"$bench"
        for dev in h2h d2d
        do
            cmd="numactl -C 1 ./$exe $gen_opts"

            [ "$server" != "" ] && cmd+=" $server"
            [ "$bench" == "bw" ] && cmd+=" $bw_opts"
            [ "$dev" == "d2d" ] && cmd+=" $d2d_opts"
            [ "$dev" == "d2d" ] && \
            [ "$bench" == "lat" ] && \
            [ "$verb" != "read" ] && \
                cmd+=" $inl_opts"

            if [ -z $server ]
            then
                echo $cmd
            else
                sleep 1
                txt=$exe"_"$dev.txt
                out=' | tee -a $txt'
                echo $cmd | tee $txt
            fi
            eval $cmd $out
        done
    done
done
