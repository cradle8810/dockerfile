#!/bin/bash

CRF_QUALITY=23

# Options
while [ "$#" -gt 0 ]; do
  case "$1" in
    -q)
      CRF_QUALITY="$2"
      shift 2
      ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      INPUT="$1"
      shift 1
      ;;
  esac
done

# Check requirements
for cmd in ffmpeg MP4Box exiftool stat touch rm; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' not found." >&2
        exit 1
    fi
done

DIRNAME=$(dirname "$INPUT")
BASENAME=$(basename "$INPUT")
BASENAME="${BASENAME%.*}"

HEIC_DIR="$DIRNAME/heic"
HEIC_OUTPUT="$HEIC_DIR/$BASENAME.heic"
HVC_OUTPUT="/tmp/temp_${BASENAME}_$$.hvc"

if [ -f "$HEIC_OUTPUT" ]; then
    echo "Skipping: $HEIC_OUTPUT already exists."
    exit 0
fi

mkdir -p "$HEIC_DIR"
TIMESTAMP=$(stat -c %y "$INPUT")

# Step 1: Encode to Raw HEVC stream
echo "  > Step 1: Encoding to HEVC stream..."
ffmpeg -i "$INPUT" -c:v libx265 -crf "$CRF_QUALITY" -pix_fmt yuv420p -f hevc -y "$HVC_OUTPUT" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "  > Error: FFmpeg failed."
    rm -f "$HVC_OUTPUT"
    exit 1
fi

# Step 2: Wrap into HEIF (Using a safer syntax for latest MP4Box/GPAC)
echo "  > Step 2: Wrapping into HEIF container..."

MP4Box -add-image "${HVC_OUTPUT}":primary -new \
    -ab heic -ab mif1 -ab iso8 -ab imfe \
    "$HEIC_OUTPUT" 2>/dev/null

if [ ! -s "$HEIC_OUTPUT" ]; then
    MP4Box -add-image src="${HVC_OUTPUT}" -new \
        -ab heic -ab mif1 -ab iso8 -ab imfe \
        "$HEIC_OUTPUT" 2>/dev/null
fi

if [ ! -s "$HEIC_OUTPUT" ]; then
    echo "  > Error: MP4Box failed. Try checking 'MP4Box -h import' for syntax."
    rm -f "$HVC_OUTPUT"
    exit 1
fi

# Step 3: Metadata and Timestamp
echo "  > Step 3: Copying metadata and timestamp..."
exiftool -tagsFromFile "$INPUT" -all:all --icc_profile -overwrite_original "$HEIC_OUTPUT" 2>/dev/null
touch -d "$TIMESTAMP" "$HEIC_OUTPUT"

rm -f "$HVC_OUTPUT"
echo "  > Successfully converted to $HEIC_OUTPUT"
