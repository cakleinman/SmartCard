# Real-device QA checklist

Run this after any content edit and before sharing the file widely. Order is intentional: fast checks first, slow checks last.

## A. Local sanity (1 min)

- [ ] `node /tmp/smoke.js` → 14/14 pass, 0 errors
- [ ] `node /tmp/smoke2.js` → 8/8 pass, 0 errors
- [ ] `du -h index.html` < 4 MB (with audio bundled) or < 200 KB (no audio)

## B. Desktop preflight at 390 px (5 min)

Open `index.html` in Chrome with DevTools → Device Mode → iPhone 14 Pro (390 × 844). Walk:

- [ ] Home renders 14 deck rows in 4 sections; "Tip" banner can be dismissed; tap any row → Deck screen opens
- [ ] Deck screen: progress ring shows 0%, segmented mode picker has only the modes that apply to that deck
- [ ] **Soldier's Creed → Type from memory**: bar docks at bottom; type the first line, press Enter; line marks done; advance through all 13 lines; end-of-session shows score
- [ ] **General Orders → Cloze**: blanks render inline; tap one → sticky bar appears; type, Enter; correct flips green; "Reveal" reveals
- [ ] **Phonetic → Flashcards**: first card requires typed commit; type "alpha", Check; flip animates; Next; second card — same flow; after a card moves up a box, no commit required → tap-to-flip + Again/Hard/Good
- [ ] **Phonetic → Match**: 6 pairs render; tap a left tile, then right tile → if correct, both lock grey; mismatch pulses then deselects; complete round → next round; complete deck → end screen
- [ ] **Phonetic → Speed**: 60s countdown bar; 4 MC buttons in 2×2; tap right → green outline; tap wrong → red outline + reveal correct; auto-advances; end shows "best: N"
- [ ] **Chain of Command → Tap in order**: pool of 14 tiles; tap President first → moves to placed stack with "01."; wrong tap nudges; complete → end screen
- [ ] **PRT Prep → Tap in order**: same as above, 10 items, ordered correctly (Bend & Reach first, Push-up last)
- [ ] **Battle Buddy → Recall in 60s**: 8 dimmed cards; type "alone" → matches "Never leaving your buddy alone" → that card brightens; type random word → input border flashes red; finish all 8 before time → end with score
- [ ] **SPOT Report → Scenario drill**: scenario text shows; S prompt; type "4 enemy soldiers" → matches; A prompt; etc.; end shows score
- [ ] **Army Values → Match**: 6 pairs with definitions
- [ ] **Land Nav → Reference**: read-only body
- [ ] **Soldier's Creed → Listen (audio mode)**: TTS button works (tap → device voice reads creed); banner mentions Settings → Bundled recordings
- [ ] Settings sheet opens from gear icon, closes on backdrop tap, theme Auto/Light/Dark switches palette live
- [ ] Refresh mid-session → progress restored, Continue card on Home points back

## C. Audio import (3 min, desktop OK)

- [ ] Settings → Bundled recordings → "Import" for Soldier's Creed → pick any small MP3 → status shows "Imported · N KB", button changes to "Replace" + "Remove"
- [ ] Navigate to Soldier's Creed → Listen → audio element appears with the imported file; "Imported recording" caption shown
- [ ] Settings → Bundled recordings → "Remove" → Listen returns to TTS fallback
- [ ] Import a > 4 MB file → alert; nothing imported

## D. Real Android phone (Chrome) — 10 min

- [ ] Send `index.html` via Drive / Signal / email; open from Files. Chrome opens it from `file://`.
- [ ] All sections in B work (especially fill-in: keyboard does not cover the answer bar)
- [ ] Vibration fires on a wrong tap in Sequencer (haptics on by default)
- [ ] Chrome menu → Add to Home screen → home icon shows "SC"; tap → app opens fullscreen-ish, **progress persists** across kills
- [ ] Tap the speaker on a phonetic flashcard with TTS enabled → device reads "A, Alpha"
- [ ] Rotate to landscape during Phonetic → Speed → 4-button layout switches to a single column

## E. Real iPhone (Safari) — 10 min, optional

iPhone is secondary. iOS does NOT allow A2HS from `file://`; users will re-open from Files each time. localStorage on `file://` is also evicted after ~7 days without A2HS.

- [ ] AirDrop file → open from Files → all of B works
- [ ] Sticky answer bar in Cloze stays above the keyboard (this is the #1 UX risk on iOS)
- [ ] Phonetic flashcard with TTS: VoiceOver (Settings → Accessibility → VoiceOver) reads "A, Alpha" when focused
- [ ] Reduce Motion (Settings → Accessibility → Motion → Reduce Motion ON) → flashcard cross-fades instead of 3D-flips
- [ ] Long-pressing a tile does NOT trigger iOS link preview
- [ ] If user uploads `index.html` to any web URL once and Adds-to-Home-Screen from there, A2HS icon renders correctly (180 × 180 PNG)

## F. Transfer paths

- [ ] AirDrop iOS → iOS: file lands in Files
- [ ] AirDrop iOS → Mac → Drive → Android: file plays nicely
- [ ] Gmail attachment open: opens inline as HTML in Android Chrome; iOS may show source — save to Files first
- [ ] Signal / Telegram document send: both deliver as `.html` and open correctly

## G. Content fidelity (15 min, do once after content edits)

For each deck, line-by-line vs the source PDF (`/tmp/smartcard.txt`, `/tmp/smartcard_p2.txt`):

- [ ] Soldier's Creed — 13 lines, exact wording
- [ ] General Orders — 3 orders, exact wording
- [ ] Army Song — Intro, Verse, Refrain
- [ ] Army Values — all 7, definitions
- [ ] Chain of Command — 14 levels, **National Guard variant**: President → National Guard → SecDef → Sec of (the) Army → Army Chief of Staff → Field Army → Corps → National Guard Adjutant General → Division → Brigade → Battalion → Company → Platoon → Squad
- [ ] Phonetic Alphabet — 26 letters, NATO spellings (Juliet single-T per the card)
- [ ] Numbers — 0–9, especially: **8 = "Ait"** (PDF showed OCR "AIT") and **9 = "Niner"**
- [ ] Battle Buddy — 8 bullets
- [ ] SPOT Report (SALUTE) — S/A/L/U/T/E and Unit / **Uniform**
- [ ] Officer / NCO / Drill Sgt protocol — 3 rows
- [ ] D&C Formation, D&C Marching — full term lists
- [ ] PRT Prep — 10 in order (Bend and Reach first, Push-up last)
- [ ] PRT Recovery — 5 in order (Overhead Arm Pull first, Single-Leg Over last)

## H. Performance (1 min)

- [ ] Open Phonetic → Match on a 4-year-old Android (Pixel 4a / Galaxy A52 class). Animations should feel 60 fps, no jank.
- [ ] Parse-to-interactive < 1 s on the same device (ballpark, eyeball it).

## I. Privacy

- [ ] Search the file for any personal data: `grep -i "kiel\|jessica\|taylor\|klein\|722-\|432-" index.html` should return **nothing**.
