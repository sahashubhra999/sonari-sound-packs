#!/bin/bash
# Add a new sound pack to the Sonari catalog.
#
# Usage: ./add-pack.sh <pack-id> <path-to-soundfont.sf2> "<Pack Title>" "<license line>"
#
# What it does:
#   1. Computes the SHA-256 of the SoundFont.
#   2. Creates the GitHub release <pack-id>-v1 with the file as its asset.
#   3. Prints the exact Swift snippet to paste into
#      Sonari/Sources/Sonari/Services/Audio/SoundPackCatalog.swift.
#
# Requirements: gh CLI authenticated as the repo owner (gh auth status).

set -euo pipefail

if [ $# -lt 4 ]; then
    echo "usage: $0 <pack-id> <soundfont.sf2> \"<Pack Title>\" \"<license line>\"" >&2
    exit 1
fi

PACK_ID="$1"
SF2_PATH="$2"
TITLE="$3"
LICENSE="$4"
TAG="${PACK_ID}-v1"

if [ ! -f "$SF2_PATH" ]; then
    echo "error: $SF2_PATH not found" >&2
    exit 1
fi

SHA=$(shasum -a 256 "$SF2_PATH" | cut -d' ' -f1)
SIZE_MB=$(( $(stat -f%z "$SF2_PATH") / 1048576 ))
ASSET_NAME="${PACK_ID}.sf2"

# Release assets must carry the pack id as the file name.
STAGED="$(mktemp -d)/${ASSET_NAME}"
cp "$SF2_PATH" "$STAGED"

echo "Uploading ${ASSET_NAME} (${SIZE_MB} MB) as release ${TAG}..."
gh release create "$TAG" "$STAGED" \
    --title "$TITLE v1" \
    --notes "$LICENSE SHA-256: $SHA"

cat <<SNIPPET

Release created. Add this pack to SoundPackCatalog.swift:

    private static let ${PACK_ID//-/_} = SoundPack(
        id: "${PACK_ID}",
        name: "${TITLE}",
        caption: "<one honest line>",
        sizeMB: ${SIZE_MB},
        downloadURL: URL(string: "https://github.com/sahashubhra999/sonari-sound-packs/releases/download/${TAG}/${ASSET_NAME}")!,
        sha256: "${SHA}",
        license: "${LICENSE}",
        voices: [ /* curate the preset list by hand */ ]
    )

Then append it to \`packs\` and update the README table here.
SNIPPET
