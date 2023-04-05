#!/bin/bash

NUM_GPUS=$(($1))
NUM_CPUS=$((16*$NUM_GPUS))

rm tmp*.txt

nvidia-smi --query-gpu=memory.used,utilization.gpu --format=csv > tmp.txt \
&& tail -n +2 tmp.txt > tmp2.txt

touch tmp3.txt
while read -r line;
do
    IFS=',' read -ra my_array <<< "$line"
    mem=${my_array[0]}
    mem=$(echo $mem | tr -dc '0-9')

    perc=${my_array[1]}
    perc=$(echo $perc | tr -dc '0-9')

    product=$(($mem*(2-(100-$perc)/100)))
    echo -e "$product" >> tmp3.txt

done < tmp2.txt
cat tmp3.txt \
&& nl -w2 -s' ' tmp3.txt > tmp4.txt \
&& cat tmp4.txt \
&& sort -k2 -n tmp4.txt > tmp5.txt \
&& cat tmp5.txt \
&& awk '{print $1}' tmp5.txt > tmp6.txt \
&& cat tmp6.txt \
&& head -$NUM_GPUS tmp6.txt > tmp7.txt \
&& cat tmp7.txt

arrVar=()
c=1
while read -r line;
do
    if [ $c -lt $NUM_GPUS ]
    then
        arrVar+="$(($line-1)),";
        c=$[c+1]
    else
        arrVar+="$(($line-1))";
    fi;
done < tmp7.txt

echo "The top $NUM_GPUS free GPUs are: $arrVar"
arrVar2="device="$arrVar
arrVar3="\""$arrVar2"\""


docker run \
    --interactive --tty \
    --rm \
    --user $(id -u):$(id -g) \
    --cpus $NUM_CPUS \
    --gpus $arrVar3 \
    --volume $PWD:$PWD \
    --workdir $PWD \
    gianlucacarloni/cond_gen:distributed_v0.1 $NUM_GPUS $arrVar
