# S65 digest - the scale is read, day one is calm, the board is legal; watch take two (Claude, 2026-09-24)

Lane: management + GUI; Claude integrates the engine/motion agents. Commits `cb3dda9a` (the three fixes),
`5960127c` (C186 ceiling), `8eb36154` (camera follows the fight, take two), merges of C184, U153, C185, U155, C186.

## The three worst career-walk findings (lead's pick - the operator had not named theirs)
1. **The weight cut had no teeth - and it was wider than one fighter.** Board offers are due THIS week on day 0,
   so the weigh-in slot (the day before) is ALWAYS behind the calendar, and `_resolve_weigh_ins` fires only on the
   day it reaches: **no board bout had ever weighed in.** `resolve_overdue_weigh_in()` weighs a passed slot in at
   signing (and at the ring door, for older saves); WeightCut's real miss rules and night penalty now apply.
   Walk: `76.8 SCHEDULED, fine 0%` -> `72.6 MADE WEIGHT (cut 5.5%)`.
   It exposed a second defect: a board offer names no rules, so `_fight_camp_ruleset` fell back to the GYM's
   ruleset - a boxing gym's MMA starter fought under boxing rules and weighed in at the boxing limit (66.7 kg vs
   the MMA 77.1 the booking read). A board bout is now fought under the fighter's own discipline.
2. **Day one opened in a crisis.** Starters never had a wage (the generator sets none). An inherited contract now
   reads as market pay until its first renewal - no cash shock ($25k would last ~8 weeks at market) - and the
   alert prints the real share of market (it printed the satisfaction part: "50%" for full pay).
   Walk: loyalty `STRAINED 38` -> `NEUTRAL 48`; NEEDS YOU 3 -> 2; THE DAY reads "all clear".
3. **The board booked nonsense.** A generated opponent drew a gym-mate's exact name from the same name lists
   (redrawn on its own stream - no other offer field moves); an amateur federation must run the fighter's
   discipline (a boxer was offered 14 Cyprus MMA Federation bouts). Walk: `VS RAFAEL NOVAK` -> `VS WESLEY DUARTE`.
Before/after sheets: `previews/s65_walk/` (sent). Walk plan: 25 steps, no dead end, gym-hub route
(THE DAY no longer lists a fighter on day one - the fix working).

**NOT fixed, next:** the boxer now has NO amateur bouts (Cyprus has no boxing federation card) and SCHEDULE says
"0 OFFERS" while the profile lists 3 (U4 D2 hides pro tier offers from amateurs on SCHEDULE only);
"NOT KNOWN: SEX, HELD UNTIL WEEK" leaks on each amateur row; the weight flag fires for an unbooked fighter.

## Gates
`career_loop_walk_test` extended (day one x3, name collision, ruleset per discipline, federation discipline,
weigh-in at signing) - **4 mutants caught** (6/1/5/1 fails). `schedule_hub_panel_test`'s escape clause is now
per-fighter. `ambitions_test`'s fixture moved a man two classes without his weight (missed by 6.4 kg once the
scale was read) - fixed. Focused tier 37/1 (`weight_cut_test`, red on the OLD tree with the same two fails).
Full suite **376/11**, read off the run: the nine documented S64 reds plus `ambitions_test` and `day_feed_screen_test`, both dormant defects the fixes woke (a fixture moving a man two classes without his weight; a quiet day's board named `day` with its gold on `today`), fixed AFTER the suite ran them - each passes alone (0 failures). Effectively S64's 376/9.

## Watch loop - take two (seed 92012, sent beside take one)
Collected and verified here: **C184** (take one), **C185** (walk layer no longer turns the punch), **U155** (UFC 30 ft
cage, N-gon circumradius, limb clamp), **C186** (hand-writer trace; wrist bound) and **U153** (live grip witness: solve
ON is WORSE on cage-clinch grips, 0.28-0.35 m either way). **Claude changed C186's ceiling 4.2 -> 12 m/s**: 4.2
killed the 18-25 m/s teleports but held every real punch under half a fist's speed (the hook source moves 0.45 m
per frame); the 0.15 m/frame threshold behind it was Claude's own C185 spec. Merged trace, frames 0-619: no hand
over 0.40 m/frame; **hips jump 0.512 m at frame 279** (-> C187).
**Found only by opening the video:** U155's bigger cage + a camera authored about the canvas centre lost both men
for ~15 s (25-45 s, empty mat). `FightCameraRig.apply` takes a pivot; the room eases it to the pair's midpoint
(tau 0.6 s, `camera_follow`). Re-recorded: both men in every 5 s tile. The full-res take two is 59.7 MB (moving
camera) - over the 50 MB rule; the side-by-side is 10.7 MB.

## Merged late (integration branch `claude/s65-integration`, `db5094a3`) and take three
**U156** (Cursor): one stature definition - 1.74/1.82 were stale mount constants, 1.49 was Head-bone-to-sole in a crouch;
the demo pair is now 1.75/1.85 m from `height_cm` (no identical frames). **U158** (Cursor, the operator's 'kicks like
bullets'): kick seek clamped to <= contact - 0.2 s, tempo capped 1.05x, full busy window; walk rate eased, leg blend
0.18 s - partial: the round kick still peaks 21.4 m/s at native speed, planted-foot drift 0.22 m. **C187** (Codex): the
hip jumps were the pelvis changing owner when the walk splice entered/left mid-clip - smoothed, plus a 4 m/s bound on
the frame's composed root motion; hip jumps >0.25 m/frame 10 -> 0. **U157** (Cursor): the grip solve LOOSENED the
live clinch through a world-fixed offset; loosening goals are now skipped (ON == OFF), but the hands still sit
~0.16-0.19 m from the neck. **The ticking clock** (Claude, the operator: 'i do not want to see seconds jump from 6
to 13'): the HUD clock was written once per exchange; now per frame - `fight_world_live_test` max jump 2 s per 1.2 s
step, mutant 14 s caught. Integration tier 29/1 (realism at its 8 ceiling), grip tier 7/0 + c169 1/0.
**Take three** (seed 92012, sent beside take two): the clock ticks 0:01..0:23 with no jump (checked frame by frame);
both men in frame on all 12 tiles.

## Not merged
**Q165/Q166 (Qwen, ground game)** - round 2 MEASURED (`9dd3bd8b`): shoot-only proximity factor -> ground 20% (anchor
15-25), TD 1.75/15 min (2.5-3.0), leg share 7.2% vs the OLD tree's 8.1% (14-18: still away), and only **2 of 16**
fights go the distance (real MMA ~half) - too many finishes. Held. **The finding that matters now:** the room's
`GRAPPLE_BEATS_DEFAULT=false` shows 0 grapple beats while the engine produced 8 - the operator's 'no ground game' was
mostly the screen (S66: record with it ON). **Q164** (10-8 rounds) still queued.

## C189 - the control arm (Codex, merged `37e5abfc`) - the answer to the operator's 'why'
Same owned H2H clips, one difference per arm. A (our fighter, whole) wrist 16.6 / ankle 6.6 / hips 3.1 m/s; B (vendor
mannequin) 19.5 / 6.6 / 3.2 - **the retarget is not the problem; our fighter can look like the preview.** C (room
entry/tempo/cut clocks) 24.1 / 10.0 / 8.4. D (live room) ankle **52.8 / 75.2**, hips 27 / 33. From D, one factor:
body_layers off -> ankle 9.6 / 9.3; **engine_positions off -> 5.6 / 6.7**. #1 = the sim placing bodies + the walk
splice; #2 = seek/cut; tempo no effect (G87 had #1/#2 the other way). C189's tree predates C187/U158 - C190 re-measures
first. **C190 launched** (the fix); sheet + video sent to the operator.

## Grok
**G62 collected** (`G62_COMPETITOR_SURVEY.md`, 96 sources): no threat; the parity gap is promoter-side commerce,
AI rival organisations that poach, a press/hype layer, a database editor. Boxing Club Manager went MIXED on
price-vs-content, an untrusted sim, abandonment and OPAQUE systems - "3D was the pitch and not the save".
**G86 collected** (`G86_PHYSICS_HIT_REACTIONS.md`): shipped fight games use physics PARTLY - a 0.2-0.4 s spring on the struck head/torso; Godot 4.7 does it officially; it does NOT fix clipping. Queued as Codex C188.

## The operator's ruling on quality (verbatim)
"We are not buying other clips unless I see the quality that I see on the YouTube preview videos. In our game, ask other agents why this is happening. Where, why is our pipeline doesn't handle it like in the preview videos? I want this fixed."
The two reels are RamsterZ's; **we own the Hand to Hand Set shown in one** (124 FBX, bound ~295x), so the same clips look smooth there and rough here - the loss is our playback: seek/tempo/cut at 20 Hz beats, root motion discarded + a spliced walk, retarget to generated meshes, attack and reaction chosen apart. Asked in parallel: **Codex C189** (control arm on our tree, one difference per arm), **Grok G87** (how shipped games reconcile a sim that owns timing with mocap; rank our steps), **Cursor U158** (kicks 'like bullets', the walk).
