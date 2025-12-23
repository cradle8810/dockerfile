# Waifu2x (waifu2x-converter-cpp)

## Without iGPU (CPU Only)
```
docker run --rm -it \
    -v $(pwd):/images \
    waifu2x -i input.jpg -o output.png -n 2 -s 2 -g -1
```
