# GrappleMap pictures for the card game's BJJ cards (GRAPPLEMAP1, S540)

The owner sent https://eel.is/GrappleMap/index.html: "the eel.is link could be used for the 2d display maybe".
GrappleMap is a free, public-domain map of grappling: every position is a pose of two bodies, every move is a short
animation of both bodies. This folder reads that map, keeps only the part the card game needs, and draws a picture for
each BJJ card so nobody has to draw the two bodies by hand.

## Where the data comes from

- Source: https://github.com/Eelis/GrappleMap, file `GrappleMap.txt`, commit `032c8f91809786b7b784852abd07cf3e10c0ea35`
  (2020-03-14, the latest on the repository), 2,674,097 bytes, sha256 `734c5af03958f7384af1c09b18bf06500748a8c505573e5be9a48174ddcfb74e`.
- License, verbatim from the repository's LICENSE file:

  > All authors involved in the creation of the contents of this package have agreed to release their respective
  > contributions into the Public Domain.

  No attribution is required; this line is here because the project keeps its sources.
- The whole file is **not** in git (2.6 MB, and every reader would only want a corner of it). `node parse.mjs` and
  `node slice.mjs` need it in this folder; `proto/grapplemap/.gitignore` keeps it out of commits.

## What the file is, in its own numbers

`node proto/grapplemap/parse.mjs` prints what the file says about itself, counted from the text (nothing is hardcoded):

| what | count |
|---|---|
| positions (one pose of both figures, named, with tags) | 601 |
| transitions (a move: 3-40 poses in a row) | 1,485 |
| poses inside those transitions | 7,722 |
| distinct tags | 161 (2,312 uses) |
| joints per figure (46 per pose, 2 figures) | 23 |

The format is GrappleMap's own: a record is some description lines (name, `tags:`, `ref:`, `properties:`) followed by
data lines that start with a space, four per pose, 69 base62 digits each. Two digits are one coordinate in thousandths
of a metre, offset by 2 m; 23 joints x 3 coordinates x 2 figures = 276 digits per pose. The parser follows
`src/persistence.cpp` and `src/players.hpp` from the same repository, not a guess: the test checks that the bones come
out the length GrappleMap's own limb table says (0.43 m shin, 0.29 m upper arm, 0.165 m neck-to-head, ...).
A transition's two ends are matched to named positions the same way GrappleMap's loader does it (the pose may be
turned about the vertical axis, mirrored, or have the two players swapped).

## What was taken: the BJJ slice

`bjj_slice.json` is the extract, `bjj_slice.gm.txt` is the same records copied verbatim out of `GrappleMap.txt` (so the
test can prove the JSON is the file's own numbers). Ids are the file's own record order - positions first (0-600), then
transitions (601 upwards), which is also how the game's grapple graph numbers its moves.

**6 of 6 BJJ cards got a picture, plus 2 of 2 shared core cards (8 of the 8 cards in the BJJ deck).**

| card (printed) | GrappleMap move | id | why this move |
|---|---|---|---|
| Sweep (shot, 2 wind, from B0/B1) | "hip bump sweep", 5 frames, tags `sweep`, `bottom` | 894 | the bottom player in a broken-open closed guard rolls up and over: the card's own sweep |
| Guard pass (advance, from T0-T2) | "bull fighter pass", 5 frames, tags `pass_around`, `top` | 752 | the standing player walks the legs aside and comes down past them |
| Triangle (hold, from B0) | "triangle", 8 frames, `bottom` | 704 | closed from full guard, the card's own bottom guard rung |
| Armbar (hold, from B0/T2/T3) | "arm bar", 6 frames, tags `armbar`, `bottom` | 1458 | finishes onto GrappleMap's own position "arm lock" |
| Rear choke (hold, from T3) | "rear naked choke", 5 frames, tags `rear_naked_choke`, `top` | 716 | back control with the arm trapped, which is the card's T3 rung |
| Kimura (hold, from B1/T1/T2) | "kimura", 9 frames, tags `kimura` | 1786 | finishes into GrappleMap's "half guard kimura", the card's half guard rungs |
| Sprawl (core, answers a takedown) | "sprawl to head&arm", 3 frames, tags `sprawl`, `top` | 983 | a sprawl on a low double leg, ending in GrappleMap's named sprawl |
| Escape (core, "stand up") | "stand up escape", 6 frames, tags `stand_up`, `bottom` | 632 | the bottom player stands up out of a pass being laid |

The extract itself: 12 positions (both named ends of those moves, where GrappleMap has a name for them) and the 8
moves. Cards whose GrappleMap move does not exist would be listed with `"noMatch"` instead of a move; none of the BJJ
cards needed that.

## The pictures

`node proto/grapplemap/slice.mjs` writes `out/<card>.svg` (512x512, one per pictured card) and `out/index.html`
(the contact sheet: every card, its printed numbers, the move it got and why, and the 12 positions).

- Side view, orthographic: the camera turns about the vertical axis until blue stands to the right of red, then looks
  along z. One turn per picture, so a move does not swing about while it plays.
- Both figures, red (player 0, GrappleMap's top) and blue (player 1), limbs as round-capped strokes, a paper casing
  under each figure so the nearer body reads where the two overlap, and the far side of each body drawn faded.
- A move is all of its frames in one SVG, stepped by CSS - it plays in any browser with no script and no animation
  file. A position is a single still.
- Framing: every picture is fitted to the frame with a 34 px margin, so both figures are always inside it (the test
  checks every drawn point of both figures against the frame).

What it is not: a 3D view. Grappling is two bodies in the same space, so a side view makes the near and far limbs of
both figures cross; the fade is the only depth cue. The shapes are GrappleMap's stick figures - correct bodies, not
our MetaHuman characters. For a card-sized illustration that is what was wanted here (docs/PICS2D1_RESULT.md showed
how much work a hand-made picture per move costs: about 20 takes per art, and the BJJ takes do not exist).

## Files

| file | what it does |
|---|---|
| `parse.mjs` | reads `GrappleMap.txt` into positions and transitions (names, tags, refs, joint coordinates per frame), prints the counts above; also writes a pose back out in the file's format |
| `render2d.mjs` | one position or one transition to a 512x512 SVG, both figures, side view; `node render2d.mjs transition 293 out.svg` |
| `slice.mjs` | the card-to-move table, writes `bjj_slice.json`, `bjj_slice.gm.txt`, `out/*.svg`, `out/index.html` |
| `grapplemap.test.mjs` | `node --test proto/grapplemap/grapplemap.test.mjs` |
| `bjj_slice.json` | the small extract: the 8 card moves, their 12 named end positions, and where they came from |
| `bjj_slice.gm.txt` | those records verbatim from `GrappleMap.txt`, for the test |

## Tests

`node --test proto/grapplemap/grapplemap.test.mjs` (9 tests, all passing). They check: the parser's counts against a
straight count of the extract's own text; the tags against the `tags:` lines; the joint decoding against GrappleMap's
limb lengths; a pose through the file format and back; every slice entry against the verbatim extract; the extract
against the full `GrappleMap.txt` and its sha256 (that check reports itself skipped when the 2.6 MB file is not in the
checkout, since it is not committed); every BJJ card in `proto/cardgame/cards.mjs` having a move and a picture; and
every picture having both figures wholly inside its frame and being exactly what `render2d.mjs` draws today (so no
hand-edited SVGs). Changing a number in the slice, moving a point outside the frame, or dropping a card all make the
suite fail - checked by doing exactly that.

Nothing outside `proto/grapplemap/` was changed. `proto/cardgame/cards.mjs` is read (the card names and numbers are
quoted in the slice and on the contact sheet), never written.

Re-running the whole thing needs the source file and about two seconds:

```
curl -sSL "https://api.github.com/repos/Eelis/GrappleMap/git/blobs/dd9cecb4e5e53c0870c93dd82eb1eabae221e3a7" \
  | node -e "const j=JSON.parse(require('fs').readFileSync(0,'utf8'));require('fs').writeFileSync('proto/grapplemap/GrappleMap.txt',Buffer.from(j.content,'base64'))"
node proto/grapplemap/parse.mjs
node proto/grapplemap/slice.mjs
node --test proto/grapplemap/grapplemap.test.mjs
```
