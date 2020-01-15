#!/bin/bash

echo "dir: $PWD" >> ${CMD_LIST}
echo "${@:2}" >> ${CMD_LIST}

/bin/bash "$@"
