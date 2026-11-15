# S479 digest (2026-11-15)

## Glove clipping (CLASH4 -> CLASH5)
- Qwen's CLASH4 (PR 297): OWN_ROUNDS 2 -> 3. Its result page said 3 frames -> 1 on 4242 08_jab; main already had 1 (0.054 m
  at f40). It also broke the brief ("keep OWN_ROUNDS"). Closed, not merged.
- Claude tried reading "late" by drawing order (`peer.shown_f <= shown_f`) instead of "not drawn this frame". Film seed 4242:
  every shot IDENTICAL to main (08_jab f40 0.054, 09_jab f19 0.057). With both skeletons drawn every frame the two rules agree;
  reverted.
- The cause the film shows: at f40 a glove moves 12 cm in one frame (`f39 2.2 m/s 0.429 m, f40 18.2 m/s 0.313 m`). Each boxer
  reads the other's arms a frame old plus last frame's move; a one-frame jump cannot be predicted. CLASH5 (Qwen, branch
  qwen/clash5): name the layer or clip change that jumps the glove, fix it there (no guard-hand move > 6 cm a frame), or, if
  it is a real fast move, read a jumped arm with no extrapolation.

## Fight week v9 (AMATEURWEEK1)
- Critics: Dola depth 7, design 7; John depth 7, design 6, play 7 -> passed (6/6 and depth 7).
- Frame B, the sparring partner screen, drawn: docs/mockups/s479/sparring_partner_v1.html/.png (Look B; names only in headers).
- Taken from John's 10/10 list: sparring in fight week is Mon/Tue (4-5 days out; the map's "Thu, 6 days out" was wrong for a
  Saturday show); the partner decides lines readied (CLOSE 3, PART 2, LOOSE 1). Rest of his list -> v10 with the build.
- Board: Q-S294-238 with ops/research/BOARD_AMATEURWEEK1_V9_S479.md + the drawing.
- PARTNERMATCH1 (pure module PartnerMatch.gd + test) to Arena, chat https://arena.ai/agent/01a1dd59-dec9-7c6d-a884-cfad25ce9418.

## Seats
- STYLE1: Arena's sandbox cannot download Godot (curl SSL error to release-assets.githubusercontent.com) -> Goose issue #298.
  Arena keeps pure modules whose tests CI can run.
- Club week v8: John 6/5/6 (fails), Maria 7/6/6 -> v9 to Kalli (SQ159) with both critics.
- Training K (Dola SQ154): the answer was cut off half way through the HTML -> re-asked under 20 KB (SQ160).
- Ladder v1 (Kalli SQ153) in, committed; critics next session.

## Not done
- No game code changed: no export, WHAT_TO_TRY unchanged (S478 build stands).
- His answers Q-232..238 pending.
