#!/bin/sh

/opt/bin/waifu2x-converter-cpp -i "$1" -o "${1%.png}_waifu2x.png" \
  --noise-level 2 \
  --scale-ratio 2 \
  --processor 0 \
  -j $(nproc)

touch -r  "$1"  "${1%.png}_waifu2x.png"
