# Sonari Sound Packs

Everything for publishing True Acoustic packs lives HERE, inside the Sonari repository. The working pipeline lives inside the private Sonari repository (soundpacks/); this public repo is the hosting endpoint only.

## How hosting works (and why there are two repo names)

- The **work** happens here: this folder holds the pipeline script, the index, and the rules.
- The **bytes** are served from the public repository `sahashubhra999/sonari-sound-packs` (GitHub Releases). That repo exists only because the Sonari repository is private, and private release assets cannot be downloaded by the shipped app without authentication. The public repo is a pure hosting endpoint; never work there directly.
- The app pins every pack by URL + SHA-256 in `Sources/Sonari/Services/Audio/SoundPackCatalog.swift`. Only exact verified bytes ever load.

## Published packs

| Release tag | Pack | Contents | Size | License |
| --- | --- | --- | --- | --- |
| `concert-library-v1` | Concert Library | 26 curated sampled instruments (orchestra, keys, world) from MuseScore General | 206 MB | MIT |
| `studio-gm-v1` | Studio GM | 56 curated instruments from GeneralUser GS | 31 MB | GeneralUser GS License v2.0 |
| `salamander-grand-v1` | Salamander Grand | Yamaha C5 grand, 16 velocity layers | 1.2 GB | CC-BY 3.0 (Alexander Holm) |
| `spanish-guitar-v1` | Spanish Guitar | Real classical guitar (FreePats) | 19 MB | CC0 |
| `hang-drum-v1` | Hang Drum | Real handpan in D minor (FreePats) | 26 MB | CC0 |
| `glass-voices-v1` | Glass | Played glass instruments (FreePats) | 26 MB | CC0 |
| `kalimba-real-v1` | Kalimba | Recorded thumb piano (FreePats) | 10 MB | CC0 |

## Adding a new pack

```bash
./soundpacks/add-pack.sh <pack-id> /path/to/font.sf2 "Pack Title" "Author and license line."
```

The script computes the SHA-256, uploads the release to the hosting repo, and prints the exact Swift snippet for `SoundPackCatalog.swift`. Then:

1. Paste the snippet into the catalog and curate the voice list by hand (names, captions, families). Use `SoundFontIntrospection` (or the script's preset listing) to read the font's real preset names.
2. Append the pack to `packs` and add a row to the table above.
3. Build, run the tests, and try the download in the app before shipping.

## Do's and don'ts

**Do**
- Only SoundFonts whose license allows redistribution: MIT, CC0, CC-BY (attribution in the release notes and README), GeneralUser-style free licenses.
- Only instruments that play well under Sonari's gesture system: expressive under pitch bend and vibrato, tolerant of velocity sweeps, beautiful with slow spatial playing (sustains, plucks with long ring, breath-like swells). The Hang, glass, guitars, orchestral sustains, and keys all qualify.
- Record the exact source URL, author, and license in the release notes with the SHA-256.
- Keep every asset ≤ 2 GB (GitHub's per-release-file limit). Split bigger banks by section.
- Name the asset `<pack-id>.sf2` and tag the release `<pack-id>-v1`.

**Don't**
- Never replace an existing release asset; the app pins its hash. Revisions ship as `<pack-id>-v2` plus a catalog update.
- No "no derivatives / no redistribution / non-commercial-only" licenses (NC is a judgment call; avoid it).
- No low-quality GM banks for quantity's sake, and no duplicates of ground already covered (FluidR3 is inside MuseScore General's lineage; adding it again would be noise).
- No instruments that fight the interface: fast key-switched articulation libraries, percussion-menu banks needing precise finger drumming, or anything that only makes sense with a sustain-pedal-and-88-keys posture.
- No SF3 (compressed) files; Apple's sampler reads SF2 only.

## Vetted watchlist (candidates for future packs)

- Versilian VSCO-2 CE (CC0) when a clean SF2 conversion is verified.
- FreePats: Upright Piano KW, Steel-String Guitar, Church Organ Emulation, Tubular Bells, Pan Flute (verify per-instrument licenses on their pages).
- Any CC0/CC-BY world instrument bank on Musical Artifacts after a listening pass.
