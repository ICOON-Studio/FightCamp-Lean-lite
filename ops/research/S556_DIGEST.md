# S556 digest (2026-11-25, Fable) - Ring Switches: the southpaw measured, the body jab on the page

Owner, during the session: one message, "Keep going" (after stopping a measuring run).

## What now works (one beat played in the browser by Claude, not yet by the owner)
- **The body jab is on the page with its own pictures**: lead hand, 1 stamina, 1 health, fast, reaches Mid and Long;
  a lead hand held LOW blocks it, so one lead hand cannot stop both jabs and Long has a guess (jab 13%, body jab 12% of
  beats, lead hand held low 32%).
- **An even round goes to the man who backed off less**: draws 12% -> 6%, nothing else moves.
- **Health 18** (the opponents 16 / 21 / 18): with the body jab the mirror bout was 2.7 knockdowns and 27% stopped
  (168 bouts); now 2.25 and 16%.
- **The page: 8 of 9 bars on two sets of 84 bouts**; the failing bar is the old one (the jab lands 73%, the body jab
  69%; bar 65%). The measuring player wins 54 / 51 / 40% against the Jabber, the Slugger, the Body Snatcher.
- **`pro_body_jab`**, an authored take: `tools/pics2d_bodycross_bake.gd -- take=jab` (the tool takes the punching arm as
  a setting; the body cross bakes unchanged: 56 keys of a dry run identical before and after).
- `rules_test.mjs` 34 pass (two new), `anim_check.mjs` 124 runs PASS, twelve game tests pass, the export is rebuilt.

## What was measured and NOT built
- **The southpaw: five rule versions, none passes** (6, 5, 5, 6, 5 of 9 bars). John's sourced answer (SQ333): against
  a southpaw the rear straight is thrown 25 to 40% more and lands as often; an orthodox jab lands about half as often.
  Every version throws the cross less or the same. The cause is one thing: the rear hand held high already stops the
  lead hook and the overhand, so with the cross one hold stops three big punches and the lead hand held high is left
  with the jab alone (held in 2% of beats). A one-line swap cannot make a southpaw in this game.
- **Moving costs breath** (both seats' ask): the men stop moving (feet stay 47% of beats, was 27%), 7 of 9 bars.

## Evidence
- docs/RINGSWITCH_S556.md, docs/RINGSWITCH_SOUTHPAW_S556.md, docs/BODYJAB1_RESULT.md (each: NOT GREEN list first).
- Tweak files and page patches: ops/research/s556_balance/. Raw run outputs: E:/FightCamp/tmp/s556_bodyjab/ (not in
  the repo).
- Strips of the eight body jab runs: ops/previews/s556_bodyjab/ (on the map, row "Ring Switches"; five on /review).

## Seats this session
- John SQ333 (southpaw numbers): landed 16:40, read, three versions written from it, all in the result page.
- Kalli SQ334 (the open-stance cover table): queued 17:06 with the five versions' numbers and John's facts.
- Dola SQ324, SQ327: still cannot leave the queue (her app runs without its debug port).
- No PC or cloud code seat was launched: the work was measuring runs of a few minutes each and one take judged by eye,
  each step waiting on the last.

## Findings worth keeping
- **The clip table is not what one tool writes**: a full `tools/clip_census.gd` run changes eight rows of
  `assets/data/clip_db.json` (the body cross's hand-set contact, the plain cross, the gut-shot reactions' fold fields).
  One row was added by hand.
- **Health is not in the look-ahead**: a health change leaves vtable.json identical, so it can be measured on the
  page's own table.
- **One set of 84 bouts is not enough for the knockdown bar** (2.6 then 2.8 on the same page): play `seed=2` too.

## Not good yet
- The owner has not played the page.
- A blocked or missed body jab (and body cross) is drawn at chest height: the picture tool sends a blocked body punch
  onto a cover-up whose elbows sit 0.44-0.47 m over the ribs. A low cover take is the fix.
- The look-ahead does not know the ground rule, so the opponents do not play for level rounds.
- No ruler was run on the body jab take (the body cross rulers read the right arm).

## Next action
NEXT_SESSION_PROMPT.md: Kalli's cover table measured, his play, the look-ahead learns the ground rule, a low cover take.
