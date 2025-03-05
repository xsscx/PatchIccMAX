find ../Build/Tools -type f -executable -exec sh -c 'strings "$1" | grep -q libasan && echo "$1:" && strings "$1" | grep libasan' _ {} \;
