# S554 digest (2026-11-25, Fable) - Ring Switches: the pictures finished, the seats' ideas built, one finding

Owner, mid-session: "keep improving the ringswitch , also what happenned with the brainstorming from other agents ?"

## What now works (played in the browser by Claude, not yet by the owner)
- **Guard holds on the page**: 56 of 56 hold runs pass (4 one-hand, 4 both-hands, two corners, Long / Mid / Inside).
- **A knockdown starts from the punch**: 16 of 16 runs; the fall begins 0.2 s after the contact (was 0.7 s).
- **C508** ("hook aims too high i think and too far away from the head"): both LEAD hooks that miss are near misses.
- **C509** ("visual effects when it lands showing the damage done"): a burst at the glove sized by the damage, the
  number rising from it, the health bar flashing, a pale ring on a block.
- **The seats' brainstorm built** (SQ326 Kalli, SQ328 John): a landed jab keeps him out; the ground behind each man is
  drawn; his habit is marked on the hold that stops it.
- **Rules are tested and measured on the page's own code**: `rules.mjs`, 17 tests, three probes.
- `anim_check.mjs` 116 of 116 runs on disk (12 borrowed).

## Evidence
- docs/HOLDTAKES1_RESULT.md (NOT GREEN list first; every bar that changed and why).
- Sheets and film: ops/previews/s554_ring/ (on /review as stage S554).
- Probes (400 bouts a man, seeds 1 and 2): the sensible player beat the Jabber 91% before, 96 to 98% with the jab rule;
  a fixed jab-and-move player 42% -> 57% against the Jabber with the rule, worse against the two walkers.
- **Body jab probe**: 97% -> 60% against the Jabber, the other two unchanged. Not on the page: no take.

## What each bar failure turned out to be (the S553 handover asked: look first, do not loosen)
| Bar | Verdict |
|---|---|
| lead hand high, 0.080 to 0.094 m | the bar was wrong (it measured to a point ON the face); now across the punch's line |
| rear hand low, 0.107 to 0.114 m | the pose was wrong (cuff under the chin); re-posed and re-baked |
| the other hand, 0.056 m | the bar's reference moved (a guard loop); now the take's own first picture, plus a control |
| the clinch | passes when blue ties up (half a head apart in depth); red's tie-up still fails and borrows blue's |

## Decided by Claude this session (and why)
- The jab rule is ON as a trial (`N.keep`): it gives the jab a visible job; the numbers are mixed, so it is his to judge.
- "Blocking a habit punch makes the counter +2" NOT built: it makes the easiest opponent easier.
- The body jab NOT put on the page without its own take (METHOD: the fight must be seen).
- A missed hook's glove must stay off the ducking man's gloves: two nearer stagings read as a block and were taken back.
- A new ideas brief to Kalli and John (SQ329, SQ330), without the body jab in it, so their answers are independent.

## The seats answered the same session
Kalli (SQ329) and John (SQ330): both put a BODY JAB first, without having been told the probe result. All three versions
measure 60 to 67% against the Jabber (`probe_body_jab_variants.mjs`). Both also want HURT, CIRCLE OFF and one rule per
opponent; Kalli would cut the guard bar, John makes a block cost stamina. `ops/research/RINGSWITCH_IDEAS2_VS_PROBE_S554.md`.

## Not done
Red's tie-up; the two wide rear hooks; the overhand's own take; the women's pair; the uppercut that starts too close;
the body jab take; the guard bar (his call); an export (no game file changed since S547).

## Alias list for anim_web.py
`--alias <c>_overhand_<landed|blocked|missed|ko>=<c>_rear_hook_<same>` for blue and red, `--alias blue_push=push
--alias red_push=push --alias red_clinch=blue_clinch --alias blue_step_in=blue_step_in_r2`.
Render dirs of S554 (E:/FightCamp/tmp/holdtakes1): p2, p2_hook, p2_upper, miss7 (punches); open/more, fix_holds, fix_ko,
fx_clinch (the rest).
