#!/bin/sh
echo -ne '\033c\033]0;biofuel\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/biofuel.x86_64" "$@"
