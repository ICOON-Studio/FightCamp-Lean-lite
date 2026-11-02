# LUDO ROUND 48 - VERDICT: how the 115 Mixamo clips play in the fight (S216, 2026-10-13)

Asked in the Ask Ludo chat "Gym Management Screen" (header read before sending). Ask: `LUDO_ROUND48_ASK_S216.txt` (game-facts sheet +
the 115 exact file names + 8 questions, 15.7k chars). Reply verbatim: `LUDO_ROUND48_REPLY_S216.txt` (29,747 chars, stopped inside section 3)
+ `LUDO_ROUND48_REPLY2_S216.txt` after "continue" (21,450 chars, sections 3-8 complete). Ceiling this round: ~29.7k chars per message.
Machine-readable tags (Ludo's table + Claude's changes below): `Godot/assets/data/mixamo_s215_ludo_tags.json`.

## What the fighter will do (plain words)
- A LIGHT hit (most jabs, ~70% of landed head shots) keeps today's small flinch layered over his footwork: he does not stop moving.
- A MEDIUM or BIG hit plays a real whole-body reaction from the right side: a lead hook snaps the head the right way, a straight right
  drives him straight back, a liver hook makes him clamp his elbow and fold.
- A KNOCKDOWN plays a real fall (flash: drops and pops up; heavy: head hits the canvas, struggles up at 8-9; KO: no get-up), then the
  get-up that matches how he landed (back or stomach), then a groggy stumble before he raises the gloves.
- A HEAVY punch into a high guard rattles the gloves back into his forehead.
- Win and loss: real celebrations and dejection after the decision or the KO.

## Taken from Ludo (operator approves)
1. KEEP/DROP table: 92 kept, 23 dropped (10 Mixamo punches - our native MetaHuman punches stay; 13 comic, martial-arts, stunt, rear/kidney
   hits - illegal or off-tone). Ludo's own summary said 91 / "11 punches" but listed 10 numbers: the table is the authority.
2. POWER BANDS on a landed punch's power 0..1: light < 0.45, medium 0.45-0.79, big >= 0.80. Target cadence (a measurement gate later,
   bounded, never exact): light 68-74%, medium 20-25%, big 4-7% of landed head punches.
3. SIDE = the attacker's hand (orthodox lead hook = his left); straights prefer the "front" clips; uppercuts prefer the uppercut clips.
4. KNOCKDOWNS: flash = #29 (back), #92 (shoulder, gets up from back); heavy = #107 (back), #59 (liver, stomach); KO, no get-up = #30, #60,
   #61, #109. Get-ups by landing: back -> #36 / #94; stomach -> #37 / #38 / #39 / #105 / #106. After the get-up: #56 hurt idle.
5. BLOCK RATTLE #96 when a blocked punch's power > 0.65; below that the guard absorbs it as today.
6. BLEND TIMES (s): medium in 0.06 / out 0.20; big in 0.08 / out 0.32; block rattle in 0.05 / out 0.15; knockdown in 0.10 into the
   get-up (our existing 0.10 s join); get-up out 0.28 into idle.
7. ROOT: medium and big reactions do not slide the fighter across the canvas (in place, the engine owns position); falls keep their travel.
8. RESULT: decision wait #111 / #25; decision win #110; KO win #114; decision loss #24 / #28; KO loss = the fall held on its last frame.

## Changed or rejected by Claude
- REJECTED, mechanics: Ludo's "big hit triggers a knockdown roll", "stamina regeneration 0% for 6 s" after a liver shot, guard integrity
  -15-25%, block stamina costs, and its fixed 10-count timeline. The fight engine already decides knockdowns, the count
  (C107/Q92) and damage; the animation FOLLOWS the engine and changes no number. (A new mechanic would need its own Ludo round + approval.)
- PARKED: the 9 block clips (#7, #8, #9, #10, #23, #57, #62, #75, #95). The native MetaHuman guard is the one you approved
  (Q-S210-2 "OK - keep this guard"); Mixamo block poses would replace it. Only #96 (block rattle) plays.
- PARKED: Ludo's light-hit Mixamo clips on an upper-body bone mask - our fight player has no bone-mask layer today; light hits keep the
  existing additive flinch (`human_hit_additive` / `human_flinch`, both ON). A masked layer is a later task if the light hits look flat.
- PARKED: the liver shot's two-stage "freeze then crumple" (0.35-0.70 s delay) - good, but it needs the engine's liver event first.
- REJECTED: #115 (seated victory) as the corner stool rest - a celebrating man on the stool reads wrong. Corner rest goes on the missing list.
- REJECTED from the missing list: southpaw-specific idles/walks - we mirror clips (FightClipMirror) for southpaws.
- Ludo's fall "front" = our "stomach" (face down).

## Next Mixamo batch (Ludo section 8 - needs your Mixamo sign-in when we fetch it)
Corner stool breathing loop, standing 8-count eye check, clinch tie-up (two-person), shoulder-roll guard loop, rope rebound catch,
cornerman cut/ice care, centre-ring glove touch.

## Build (already moving)
- MIXAMO1A (cloud Cursor, issue #140): every clip baked onto the MetaHuman skeleton + floor/height gates + catalogue.
- MIXAMO1C (Arena): the pure reaction picker (side, power band, knockdown -> matching get-up, no repeats).
- MIXAMO1B (next free Codex seat, after your OK on this verdict): wired into the live fight behind the `mixamo_reactions` switch, with stills
  from the game's own camera (guard, light / big head hit, body hit, knockdown, on the canvas, get-up, back in guard) for you to judge.

## OPERATOR OVERRIDE (S216, in chat, verbatim: "iwant all this in the game do what ludo suggests") - SUPERSEDES the rejections and parks above
- ALL 9 block clips are KEPT and play from Ludo's table (guard poses by punch height and side); the native MetaHuman guard stays
  the default idle guard; Mixamo block poses play on the block events Ludo maps (power band and side).
- #115 (seated victory) plays as the corner stool rest (category corner_rest), as Ludo specified.
- Liver shot two-stage reaction (freeze 0.35-0.70 s, then crumple into #5 or the liver knockdown #59): ON THE LIST. It needs the engine's
  liver event; if the fight engine does not emit one yet, MIXAMO1B adds that event as a small engine-side hook (no change to any damage number).
- Southpaw idles and walks (Ludo missing item 7) and the other missing clips (corner stool breathing, 8-count, clinch tie-up,
  shoulder-roll guard, rope catch, cornerman care, centre-ring glove touch) go into the NEXT Mixamo batch request (needs the operator's
  Mixamo sign-in when fetched).
- Ludo's MECHANICS numbers (stamina 0% for 6 s after a liver shot, guard integrity -15-25%, stamina cost per block, the fixed 10-count
  timeline) are NOT part of this verdict: they change engine numbers the engine already owns. Rejected unless the operator asks for them
  as a separate change with its own Ludo round.
