# RustChain #315 — Deterministic Render Verification

Verified on 2026-08-30 JST from the committed `generate_concrete_assets.py` at main commit `2ae16fac8546c1ae6b1a1b8601daac722f96e104`.

The renderer completed successfully with the existing free stack (Pillow 12.3.0 + ffmpeg 7.1.5). It produced exactly 3 MP4 shorts and 5 PNG memes.

## Video verification

- `shorts/01-proof-not-promises.mp4` — 242,778 bytes — H.264 — 1080x1920 — 10.000s — SHA-256 `97762e3801b0dee289c9266a44457822b0b7501b27bcf9e80c3a433886045584`
- `shorts/02-old-hardware-new-proof.mp4` — 288,410 bytes — H.264 — 1080x1920 — 12.000s — SHA-256 `4955ec5d9ddacc207489c7910eccc7abfb65d3260684b60ccccb50d1a27ad58a`
- `shorts/03-bottube-human-first.mp4` — 317,973 bytes — H.264 — 1080x1920 — 15.000s — SHA-256 `e72435e7eb2b7495a17df86f8906ee5c9872db11c0770b06faf1f9b0220ff8d1`

All three satisfy the bounty's 8–15 second vertical-video duration requirement and were independently probed for codec, dimensions and duration.

## Image verification

- `memes/01-old-hardware.png` — 47,381 bytes — PNG — 1080x1080 — SHA-256 `f392a5daff904ee0640ca3fca3097ef1843ada61d1ee72ccd9363bdacab6b313`
- `memes/02-proof-work.png` — 43,648 bytes — PNG — 1080x1080 — SHA-256 `82ad91315be04edf0b02712d18729de7002f88419cc66f34f5208bcda632539d`
- `memes/03-bottube.png` — 50,988 bytes — PNG — 1080x1080 — SHA-256 `d1d37ba5f13f54d2b27385b9d61e7b994ccea9fe1a5e9904b6124f73ed3cd5f8`
- `memes/04-revive-machine.png` — 44,983 bytes — PNG — 1080x1080 — SHA-256 `19412862b1c67b977f2b38ddc5d2feeda716b148c1746e14cc92a46e8bb0b266`
- `memes/05-human-compute.png` — 44,801 bytes — PNG — 1080x1080 — SHA-256 `b234ec4956b68882d19941445c23ea7186fa5ec8d590fcb48ce844d5e4de9887`

All five opened successfully through Pillow verification at exactly 1080x1080.

## Publication boundary

This file records deterministic render verification only. The eight binary files are **not claimed public until they are committed and re-fetched from GitHub**. RustChain #315 is **not claimed accepted or settled** without maintainer/payout evidence. Cash delta remains 0.
