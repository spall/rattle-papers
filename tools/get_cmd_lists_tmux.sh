#!/bin/bash

proj=tmux
url=https://github.com/tmux/tmux

here=$(pwd)

#commits=(ed16f51)
#commits=(61b075a e9b1294)
commits=(3e70130 8457f54 a01c9ff cdf1383 74b4240 0eb7b54 f3ea318 7cdf5ee ee3d3db 685eb38 60ab714 7eada28 7f3feb1 8b22da6 bc36700 32be954 6f0241e 19d5f4a 43b3675 0bf153d 4822130 47174f5 c915cfc 5455390 400750b 470cba3 a4d8437 6c28d0d 24cd726 9900ccd c391d50 0c6c8c4 fdbc111 37919a6 22e9cf0 ba542e4 4694afb)

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

    sh autogen.sh && ./configure
    make SHELL=${here}/cmd_shell.sh
done


