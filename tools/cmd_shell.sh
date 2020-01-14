#!/bin/bash

echo "${@:2}" &>> ${CMD_LIST}

/bin/bash "$@"
