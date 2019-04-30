#!/bin/bash
declare -a arr=(
    coauth-DBLP
    coauth-MAG-Geology
    coauth-MAG-History
    congress-bills
    contact-high-school
    contact-primary-school
    DAWN
    email-Enron
    email-Eu
    NDC-classes
    NDC-substances
    tags-ask-ubuntu
    tags-math-sx
    tags-stack-overflow
    threads-ask-ubuntu
    threads-math-sx
    threads-stack-overflow
)
declare -a pvals=(
    -1.0
    1.0
    2.0
    0.001
)
for i in "${arr[@]}"
do
    julia ../src/geom_mean_exact.jl -d $i
    for p in "${pvals[@]}"
    do
        julia ../src/p_mean_exact.jl -d $i -p $p
    done
done