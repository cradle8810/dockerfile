# Waifu2x (waifu2x-converter-cpp)

## Without iGPU (CPU Only)
```
docker run --rm -it \
  -v $(pwd):/work ghcr.io/cradle8810/waifu2x
  --noise-level 2 --scale-ratio 2 --processor 0
  infile.png
```
