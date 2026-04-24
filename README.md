# Smart Card — Soldierization Study App

A single-file mobile study app built from the Delta Co RSP "Soldierization Smart Card." Flashcards, fill-in-the-blanks, matching, sequencing, timed games, and a Leitner-spaced daily review queue. Works offline. No app store, no server, no account.

The whole app is one file: `index.html`.

## What it covers

14 decks across 4 groups:

- **Creeds & Passages** — Soldier's Creed · General Orders · The Army Song · Battle Buddy Responsibilities · SPOT Report (SALUTE)
- **Core Lists** — Army Values (LDRSHIP) · Chain of Command · Phonetic Alphabet · Military Numbers · Officer / NCO / Drill Sgt protocol
- **Drills** — D&C Elements of a Formation · D&C Marching & Manual of Arms · PRT Preparation Drill · PRT Recovery Drill
- **Reference** — Land Navigation terrain features

## How to use it

### On Android (primary target)

1. Drop `index.html` onto your phone via Drive, email, Signal, Telegram — anything that delivers files.
2. Open it from the Files app or your downloads folder. Chrome will open it.
3. Tap the Chrome menu → **Add to Home screen** so progress saves long-term and you get an icon.
4. Tap the icon to launch like an app.

### On iPhone

1. AirDrop or share `index.html` to the phone. Save it to **Files** (long-press → Move). Mark it as a Favorite for fast re-opening.
2. Tap to open. It launches in Safari from `file://`.
3. iOS won't let `file://` pages be added to the Home Screen. Two mitigations are built in:
   - The first time you tap, the app asks iOS for **persistent storage** (`navigator.storage.persist()`). When granted, your progress survives the 7-day eviction.
   - **Settings → Backup progress → Copy** writes a JSON code to your clipboard. Save it to Notes or Messages. Settings → **Restore** pastes it back if iOS ever clears the data, or onto a new phone.

### Sharing it onward

In the app: **Settings → Share this app** → uses the system share sheet to send the file via AirDrop, Messages, Mail, Drive, etc. (Android Chrome and iOS Safari ≥ 17 support the `Web Share` files API; on older browsers it falls back to a download.)

Or just send the `index.html` file directly through any channel.

## Study modes

- **Flashcards (commit-before-reveal)** — for new cards, you type or tap an answer before flipping. Mature cards switch to quick review.
- **Type from memory** — line-by-line for the Creed, Orders, and Song. Fuzzy graded (Levenshtein ≥ 0.85), so punctuation and case are forgiven.
- **Cloze fill-in** — passages with words removed; sticky answer bar above the keyboard.
- **Matching** — two-column tap-tap, six pairs per round.
- **Tap in order** — for Chain of Command and PRT drills.
- **Speed round** — 60-second timed bidirectional drill on the Phonetic Alphabet.
- **Scenario drill** — SALUTE in a real-feeling situation, not in isolation.
- **Recall in 60s** — list every Battle Buddy responsibility from memory.
- **Daily Review** — Leitner-spaced (1, 2, 4, 7, 14 days), interleaved across decks. Surfaces only what's due.

## Audio

The app has three playback paths for the Soldier's Creed and Army Song, in priority order:

1. **In-app import (per phone)** — Settings → Bundled recordings → Import. Pick an MP3 from the phone's Files. It's stored in `localStorage` on that phone only. Use a low-bitrate MP3 (≤ 96 kbps mono, < 4 MB) so it fits in the storage budget.
2. **Pre-bundled into the file** — run `./bundle-audio.sh` on a machine with internet. It downloads the public-domain U.S. Army Band recordings from Internet Archive and inlines them into `index.html` as base64 `data:` URIs. Distribute the resulting file. If the default download URLs break, pass local file paths: `./bundle-audio.sh song.mp3 creed.mp3`.
3. **Device TTS fallback** — if no audio is found, the Audio mode shows a "Read aloud" button that uses the device's speech synthesis. Free, but robotic; the Army Song really needs to be sung.

U.S. Army Band recordings are public domain under 17 U.S.C. § 105.

## Privacy & data

All progress is stored locally in your browser's `localStorage`. Nothing leaves the phone. Reset progress in Settings.

The Contact Info section from the original card was intentionally omitted — names and phone numbers should not travel with the file.

## Editing content

All deck content lives in the `<script id="content" type="application/json">` block near the top of `index.html`. Edit the JSON (mind the commas) and reload.

## Tech notes

- Single HTML file, no dependencies, no build step.
- Vanilla JS, ~1,200 LOC plus content JSON and CSS.
- Mobile-first responsive layout, light + dark palettes via `prefers-color-scheme`, manual override in Settings.
- Works under `file://` on both Android Chrome and iOS Safari.
- Respects `prefers-reduced-motion`.
- WCAG AA contrast.

## Verifying after edits

A jsdom smoke test lives at `/tmp/smoke.js` and `/tmp/smoke2.js` (see commit history). To run after edits:

```sh
cd /tmp && npm i jsdom && node smoke.js && node smoke2.js
```

22 tests cover route rendering, mode transitions, and persisted state.
