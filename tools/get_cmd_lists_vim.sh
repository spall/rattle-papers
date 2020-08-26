#!/bin/bash

proj=vim
url=https://github.com/vim/vim

here=$(pwd)

commits=(4b96df5 318e7a9 3f169ce 50985eb 89bfc82 f8ddb25 7d8ea0b 272ca95 842931c 5b18c24 07da94b 58ceca5 97a2af3 8cbd6df a6d5368 9a5e5a3 4549ece 0ff6aad 5d98dc2 db661fb e258368 70b3e70 df54382 b099202 0c3064b 2110927 9f2d020 5feabe0 92be6e3 a259d8d 705724e 0b76ad5 7f829ca 7cc9692 ab067a2)

for commit in ${commits[@]}
do
    cd ${here}
    echo ${commit}
    rm -rf output/${proj}
    mkdir -p output

    mkdir output/${proj}

    cd output/${proj}
    git clone ${url} .
    git reset --hard ${commit}

    #commit="$(git show --oneline -s | cut -d ' ' -f 1)"

    # set file to proj.commit.cmds
    export CMD_LIST=${here}/${proj}_scripts/${proj}.${commit}.cmds

    make SHELL=${here}/cmd_shell.sh
done


