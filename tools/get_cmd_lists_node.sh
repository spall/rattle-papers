#!/bin/bash

proj=node
url=https://github.com/nodejs/node

here=$(pwd)

#ab9e894 2272489 0fe8101
commits=(d80c400 54c1a09 be65963 023ecbc d10927b cb21011 43fb6ff 13fe56b 25c3f7c)
	                 # 470511a 64161f2 2cd9892 24e81d7 d65e6a5 5cf789e d227d22 1d95111)
commits2=(38aa315 d4c81be 9225939 abe6a2e dd4c62e a171314 59a1981 f2ec64f 3d456b1 70c32a6)
	    #              b851d7b 2462a2c 32f63fc 2170259 0f89419 7b7e7bd a5d4a39 78743f8)

            # 470511a 64161f2 2cd9892 24e81d7 d65e6a5 5cf789e d227d22 1d95111))

            # b851d7b 2462a2c 32f63fc 2170259 0f89419 7b7e7bd a5d4a39 78743f8)
    
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

    ./configure
    make SHELL=${here}/cmd_shell.sh
done


