#!/bin/bash

need_version=$1
current_version=$(tmux -V | awk '{print $2}')

[[ $(echo "$current_version > $need_version" | bc) != 0 ]]
