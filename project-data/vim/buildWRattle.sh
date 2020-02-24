#!/bin/bash

proj=$1 #vim
url=$2 #github url to vim
j=$3 # number of threads to build with
d=$4 # debug means do debugging; anything else means don't, but can't be empty
test=$5

# oldes to newest; first commit in list is build script
commits1=(4b96df5a0)

commits2=(318e7a9c0 3f169ce17 50985eb1f 89bfc8218 f8ddb2578 7d8ea0b24 272ca95fc)

commits3=(842931cd7 5b18c248d 07da94b0f 58ceca5ca 97a2af39c 8cbd6dfc0 a6d536829 9a5e5a3e3 4549ece47 0ff6aad39 5d98dc2a4 db661fb95 e258368b4 70b3e706b df54382ea)

commits4=(b09920203 0c3064b39 21109272f 9f2d020d3 5feabe00c 92be6e3f4 a259d8d30 705724e43 0b76ad53b 7f829cab3 7cc96923c ab067a21b)

here=$(pwd)

scripts=${here}/machine_hive/scripts

buildScript=${here}/../buildScript  # haskell program that takes a file of commands and turns them into a rattle build

projdir="/data/home.local/sjspall/icfp/rattle-papers/tools/output"

rm -rf ${projdir}/${proj}
mkdir -p ${projdir}
mkdir ${projdir}/${proj}

debug_dir=/nix/other_data/home.local/sjspall/icfp/rattle-papers/project-data/vim/${proj}_debugs_${j}
mkdir -p ${debug_dir}

cd ${projdir}/${proj}
git clone ${url} .

NANO=1000000000

for c in "${commits1[@]}"
do
    git reset --hard ${c}
    of=${debug_dir}/${proj}.${c}.rattle.out
    s1=$(date +"%s%N")
    ${buildScript} ${scripts}/vim.4b96df5a0.cmds ${debug_dir}/${proj}.${c} ${j} ${d} ${of}  +RTS -p -N &> ${of}
    s2=$(date +"%s%N")
    diff=$(( ${s2} - ${s1} ))
    echo $(( ${diff} / ${NANO} ))
    # run tests
    if [ ${test} = yes ]
    then 
	cp ${scripts}/Makefile.4b9.top ${projdir}/${proj}/Makefile
	cp ${scripts}/Makefile.4b9.src ${projdir}/${proj}/src/Makefile
	make test &> ${debug_dir}/${proj}.${c}.test.out
    fi
done

for c in "${commits2[@]}"
do
    git reset --hard ${c}
    of=${debug_dir}/${proj}.${c}.rattle.out
    s1=$(date +"%s%N")
    ${buildScript} ${scripts}/vim.318e7a9c0.cmds ${debug_dir}/${proj}.${c} ${j} ${d} ${of} +RTS -N &> ${of}
    s2=$(date +"%s%N")
    diff=$(( ${s2} - ${s1} ))
    echo $(( ${diff} / ${NANO} ))
    # run tests
    if [ ${test} = yes ]
    then 
	cp ${scripts}/Makefile.318.top ${projdir}/${proj}/Makefile
	cp ${scripts}/Makefile.318.src ${projdir}/${proj}/src/Makefile
	make test &> ${debug_dir}/${proj}.${c}.test.out
    fi
done

for c in "${commits3[@]}"
do
    git reset --hard ${c}
    of=${debug_dir}/${proj}.${c}.rattle.out
    s1=$(date +"%s%N")
    ${buildScript} ${scripts}/vim.842931cd7.cmds ${debug_dir}/${proj}.${c}.debug ${j} ${d} ${of} +RTS -N &> ${of}
    s2=$(date +"%s%N")
    diff=$(( ${s2} - ${s1} ))
    echo $(( ${diff} / ${NANO} ))
    # run tests
    if [ ${test} = yes ]
    then 
	cp ${scripts}/Makefile.842.top ${projdir}/${proj}/Makefile
	cp ${scripts}/Makefile.842.src ${projdir}/${proj}/src/Makefile
	make test &> ${debug_dir}/${proj}.${c}.test.out
    fi
    #  make test &> ${debug_dir}/${proj}.${c}.test.out
done

for c in "${commits4[@]}"
do
    git reset --hard ${c}
    of=${debug_dir}/${proj}.${c}.rattle.out
    s1=$(date +"%s%N")
    ${buildScript} ${scripts}/vim.b09920203.cmds ${debug_dir}/${proj}.${c}.debug ${j} ${d} ${of} +RTS -N &> ${of}
    s2=$(date +"%s%N")
    diff=$(( ${s2} - ${s1} ))
    echo $(( ${diff} / ${NANO} ))
    # run tests
    if [ ${test} = yes ]
    then 
	cp ${scripts}/Makefile.b09.top ${projdir}/${proj}/Makefile
	cp ${scripts}/Makefile.b09.src ${projdir}/${proj}/src/Makefile
	make test &> ${debug_dir}/${proj}.${c}.test.out
    fi
    # make test &> ${debug_dir}/${proj}.${c}.test.out
done

echo ""
