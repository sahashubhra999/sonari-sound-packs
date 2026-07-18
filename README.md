# Sonari Sound Packs

True Acoustic packs for Sonari: sampled instruments the app downloads once, verifies by checksum, and keeps offline.

Packs are published as versioned release assets. The app ships a pinned manifest (URL + SHA-256 per pack), so only exact, verified bytes ever load. Nothing here runs a server; GitHub Releases serves the files.

**This repository lives locally at `~/Desktop/sonari-sound-packs`** and is owned by `sahashubhra999`. Everything needed to publish new packs is in this folder.

## Packs

| Release tag | Pack | Contents | Size | License |
| --- | --- | --- | --- | --- |
| `concert-library-v1` | Concert Library | 26 curated sampled instruments: orchestra, keys, and world (piano, strings, choir, brass, sitar, koto, kalimba, marimba, timpani, and more) from the MuseScore General SoundFont | 206 MB | MIT |
| `studio-gm-v1` | Studio GM | 56 curated instruments from GeneralUser GS: the small-download studio workhorse (keys, guitars, basses, saxes, brass, winds, synths, world) | 31 MB | GeneralUser GS License v2.0 (free use and redistribution) |
| `salamander-grand-v1` | Salamander Grand | One Yamaha C5 concert grand, sampled at 16 velocity layers | 1.2 GB | CC-BY 3.0 (Alexander Holm) |

## Adding a new pack (the pipeline)

1. Find a SoundFont (.sf2) whose license allows redistribution (MIT, CC0, CC-BY, GeneralUser-style free licenses). Record the license and author.
2. Run:

```bash
./add-pack.sh <pack-id> /path/to/font.sf2 "Pack Title" "Author and license line."
```

   The script computes the SHA-256, uploads the release, and prints the exact Swift snippet for the app's catalog.
3. Paste the snippet into `Sonari/Sources/Sonari/Services/Audio/SoundPackCatalog.swift`, curate the voice list by hand (names, captions, families), and append the pack to `packs`.
4. Add a row to the table above and push:

```bash
git add -A && git commit -m "Add <pack> to the index" && git push
```

Rules:

- Release assets are immutable once shipped (the app pins their SHA-256). To revise a pack, publish `<pack-id>-v2` and update the app's manifest; never replace an existing asset.
- Every file ≤ 2 GB (GitHub's per-asset limit). Bigger banks split into multiple packs by section.
- Each release's notes carry the license text/attribution and the SHA-256.

## Licenses and attribution

- **MuseScore General SoundFont** (`concert-library.sf2`): MIT license. Built by S. Christian Collins and contributors for MuseScore, based on FluidR3Mono and community samples. Source: <https://ftp.osuosl.org/pub/musescore/soundfont/MuseScore_General/>
- **GeneralUser GS** (`studio-gm.sf2`): GeneralUser GS License v2.0 by S. Christian Collins; free to use and redistribute. Source: <https://github.com/mrbumpy409/GeneralUser-GS>
- **Salamander Grand Piano** (`salamander-grand.sf2`): CC-BY 3.0 by Alexander Holm; SF2 build by the FreePats project. Source: <https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html>
