#!/bin/bash

# DEFAULT VALUES
NOISE=2
SCALE=2
PROC=0

# Options
while [ "$#" -gt 0 ]; do
  case "$1" in
    --help)
      echo "--- Original waifu2x-converter-cpp help ---"
      /opt/bin/waifu2x-converter-cpp --help
      echo ""
      echo "--- Script Usage ---"
      echo "Usage: $0 [options] input_file"
      echo "Options: --noise-level [0-3], --scale-ratio [n], --processor [n]"
      exit 0
      ;;
    --noise-level)
      NOISE="$2"
      shift 2
      ;;
    --scale-ratio)
      SCALE="$2"
      shift 2
      ;;
    --processor)
      PROC="$2"
      shift 2
      ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      # オプション以外の引数（入力ファイル）
      INPUT_FILE="$1"
      shift 1
      ;;
  esac
done

if [ -z "$INPUT_FILE" ]; then
  echo "Usage: $0 [options] input_file"
  exit 1
fi

OUTPUT_FILE="${INPUT_FILE%.*}_waifu2x.png"

/opt/bin/waifu2x-converter-cpp -i "$INPUT_FILE" -o "$OUTPUT_FILE" \
  --noise-level "$NOISE" \
  --scale-ratio "$SCALE" \
  --processor "$PROC" \
  -j $(nproc)

touch -r "$INPUT_FILE" "$OUTPUT_FILE"
