#!/bin/bash

proj=$1
url=$2

here=$(pwd)

for i in {10..9}
do

    rm -rf output/${proj}
    mkdir -p output
    mkdir output/${proj}

    cd output/${proj}
    git clone ${url} .
    git reset --hard origin/master~${i}

    commit="$(git show --oneline -s | cut -d ' ' -f 1)"

    # set file to proj.commit.cmds
    export CMD_LIST=${here}/${proj}.${commit}.cmds
    
    make SHELL=${here}/cmd_shell.sh
done


