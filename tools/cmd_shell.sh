#!/bin/bash

echo "dir: $PWD" >> ${CMD_LIST}
echo "$@" >> ${CMD_LIST}

/bin/bash "$@"
