#!/bin/bash

proj=$1
url=$2
j=$3
timeordebug=$4
test=$5

commits1=(4b96df5a0 318e7a9c0 3f169ce17 50985eb1f 89bfc8218 f8ddb2578 7d8ea0b24 272ca95fc 842931cd7 5b18c248d 07da94b0f 58ceca5ca 97a2af39c 8cbd6dfc0 a6d536829 9a5e5a3e3 4549ece47 0ff6aad39 5d98dc2a4 db661fb95 e258368b4 70b3e706b df54382ea b09920203 0c3064b39 21109272f 9f2d020d3 5feabe00c 92be6e3f4 a259d8d30 705724e43 0b76ad53b 7f829cab3 7cc96923c ab067a21b)

here=$(pwd)

projdir="/data/home.local/sjspall/icfp/rattle-papers/tools/output"

rm -rf ${projdir}/${proj}
mkdir -p ${projdir}
mkdir ${projdir}/${proj}

debug_dir=${here}/${proj}_debugs_${j}
mkdir -p ${debug_dir}

cd ${projdir}/${proj}
git clone ${url} .

for c in "${commits1[@]}"
do
    git reset --hard ${c}
    if [ ${timeordebug} = debug ]
    then
	export CMD_LIST="${debug_dir}/${proj}.${c}.make.cmds"
	time make SHELL="/data/home.local/sjspall/icfp/rattle-papers/tools/cmd_shell.sh" --debug=v -j${j} &> ${debug_dir}/${proj}.${c}.make.out
    else
	s1=$(date + "%s%N")
	make -j${j}
	s2=$(date + "%s%N")
	echo $(( ${s2} - ${s1} ))
    fi
    if [ ${test} = yes ]
	then make test &> ${debug_dir}/${proj}.${c}.make.test.out
    fi

done
