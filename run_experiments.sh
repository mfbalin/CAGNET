#!/bin/bash

GRAPHS="cora_v2 ogbn-arxiv ogbn-products reddit proteins"

mkdir -p $1

for g in $GRAPHS; do
   for p in 8 4 1; do
        echo $g $p
	python3 -m torch.distributed.launch --nproc $p gcn_distr.py --accperrank=8 --epochs=40 --graphname=../mg_gcn/test/data/permuted/${g} --timing=False --midlayer=512 --runcount=1 --accuracy=False --activations=True > "${1}/${g}_${p}.out" 2>&1
    done
    echo $g 2
    python3 -m torch.distributed.launch --nproc 2 gcn_distr.py --accperrank=8 --epochs=40 --graphname=../mg_gcn/test/data/permuted/${g} --timing=False --midlayer=512 --runcount=1 --accuracy=False --activations=True > "${1}/${g}_2.out" 2>&1
done
