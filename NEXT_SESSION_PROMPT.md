# S554 handover (written 2026-11-25, S553 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S553_DIGEST.md.

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE (owner S553: "i think we should focus more on the RingSwitches"). The
  written-plan and coach probe rounds are PARKED, nothing cut (three plan probes end at 1-2 wins in 100:
  `ops/research/STYLEPLACE1_CHECK_S553.md`; Q-336 "Keep the two hire cards"). No fourth plan probe, no new coach round.
- ## METHOD - THE FIGHT MUST BE SEEN, SIDE VIEW, BOTH MEN CHEST TO THE CAMERA (owner S553, asked "Keep the side view,
  with both men facing you?": "Yes, side view"). Until S553 the player's man was drawn from BEHIND and his rear arm was
  hidden in every picture. Every render takes `south=blue`. A fall is never shown without the punch that caused it
  ("there is no hit how is that knock down ?"). A held hand shows its arm and sits where it guards ("the right hand of
  blue is not right"; "it needs to cover left side of the head"). The ranges are drawn ("inside/midrang/long").
- THE PAGE: `proto/twohands/switch.html`; `order.html` is generated (`python proto/twohands/tools/make_order.py .`; the
  generator CUTS the text between "const c = covers(me, P)" and "function plan() {": never put new code there).
- HOW HE WORKS ON THIS GAME: he looks at each picture and names what is wrong within minutes. Show pictures early, fix
  each note at once, check a new pose on BOTH corners at 480 px before showing it.
- A PAGE HE PLAYS IN CHROME NEEDS A SERVER IN A TERMINAL TAB (`python proto/cardgame/serve.py 8797 twohands`; it was up
  in S553: curl it before starting a second one).
- FIGHT ANIMATION: v2 only, no new correction layer in scripts/fight3d; an authored take baked by a tool is the route.
- HIS GAME FIRST: `Get-Process ArcheAgeChronicles` before any render. AGENTS ONLY IN THE CONSOLE.
- A script or commit message with an apostrophe goes in a FILE (a Bash heredoc broke on one again, twice); a bare `cd`
  in Bash moves the session folder (it did again: `cd /e/FightCamp/Lean && ...` in the same command).

## FIRST: finish HOLDTAKES1 (the pictures are rendered or rendering, NOT on the page)
Commit 304b4d47f holds the tools and the page code. The page still plays the S552 pictures and falls back safely.
1. The render: `E:/FightCamp/tmp/holdtakes1/full.sh` ran both batches with `south=blue` into
   `E:/FightCamp/tmp/holdtakes1/open/punches` (48 runs; done but for one gate fail) and `open/more` (holds at three
   ranges, steps, feint, knockdowns from each punch, push, clinch). Read `full.out`, `open_punches.log`,
   `open_more.log`. If `open/more` is missing or cut short, rerun the second command of `full.sh` (about 10 minutes).
   The more-set tool was only parse-checked: its three new runs (`_ko`, ranges, both-hands holds) have never rendered.
2. Two punch runs failed their gate (46 of 48 pass): `blue_body_hook_landed` (head_clear 0.570 < 0.60) and
   `blue_lead_uppercut_blocked` (read the log). S552 fixed red's body hook with `take=pro_kidney_shot` into a `fix` dir.
3. LOOK before shipping: the re-posed lead hand low (forearm across the stomach) has not been seen by anyone; the
   knockdown-from-the-punch runs are twice as wide; hold pictures at Inside may overlap the guards.
4. Convert: empty `proto/twohands/img/anim/` first (every run is new), then
   `python proto/twohands/tools/anim_web.py <open>/punches <open>/more --strips <dir>/strips` with the S552 aliases
   (overhand = rear hook, landed / blocked / missed and now `_ko`; `blue_push=push`, `red_push=push`), then
   `python proto/twohands/tools/anim_stills.py` (the stills from the runs), `node proto/twohands/tools/anim_check.mjs`
   (116 runs asked; red today: 57 missing).
5. PLAY BOTH PAGES in the browser before saying done (nothing new was played in S553): the hold shown when a switch is
   clicked, the range change, a knockdown.
6. Sheets and a film on the review board (`review_add.py --stage S553`), the four holds side by side at 480 px;
   `docs/HOLDTAKES1_RESULT.md` with a NOT GREEN list first. His eye closes it.

## The render finished after the handover was written (S553, read from its log, pictures NOT looked at)
- `open/punches`: 48 runs, 46 pass. `open/more`: 82 runs, 662 pictures, all 16 knockdown-from-the-punch runs rendered.
- 35 of the more-set runs FAILED THEIR BARS, and `anim_web.py` will NOT copy a run whose bars fail, so most hold
  pictures would not reach the page as it stands. The failures are my own first-guess bars, by a hair or by design:
  lead high 0.080-0.094 m from the face (bar 0.08); rear low 0.107-0.114 m off the line under the chin (bar 0.08: the
  glove waits at the chest); "the other hand" 0.056 m from its guard on red (bar 0.05: the guard loop itself moves that
  much). Lead low and rear high pass. DO NOT loosen a bar to pass: look at each pose at 480 px first, move the pose
  where the picture is wrong, and where the picture is right say why the bar was wrong and what it becomes.
- `red_clinch` and `blue_clinch` fail (they passed in S552 with blue from behind): the mirrored man changes the tie-up.
- One run refused: `blue_step_in_2` (a step in ending on Mid: blue's toes leave the frame). The camera is fixed on the
  last picture; start it nearer or widen that run.

## Then (his notes, not done)
- C508 on the missed lead hook: "hook aims too high i think and too far away from the head". The miss gives the other
  man extra ground AND he ducks, so the hook sweeps wide and high: make it a near miss (tools/pics2d_gate.gd MISS_*,
  the `give` in pics2d_anim.gd).
- C509: "needs some visual effects when it lands showing the damage done beside sounds". Plan: the punch run records
  the glove's place on the contact picture, the page draws a burst there sized by the damage.
- The uppercut picture he sent without words (the men chest to chest, an arm through the gloves): inside punches start
  too close (S552 open end).
- THE GUARD BAR NEVER BREAKS: 0 in 1,800 bouts (`ops/research/GUARDBAR_S553.md`). Keep-or-cut for him: cut it, or
  rebuild it so every block costs (a new rule, probe first). Asked in chat, not answered.
- Q-336 note stops mid-sentence: "thecoaches should have". Ask for the rest.
- Ring Switches itself (S551 NOT GREEN): the Jabber too easy, one-beat bots, no tests for the rules, keep the order
  page or not. Then the GrappleMap ground player.

## Not touched this session
RINGANIM1 open ends (overhand take, one-man shove, women's pair); MATCHBOTS2 hooks on disk, uncommitted; the 05:00
reds (matchmaking_bots, block_meet); NO EXPORT SINCE S547 (S553 changed no game file: the hold takes are not loaded).

## Waiting on the owner
His eye on the new pictures once they are on the page. The guard bar: cut or rebuild. The rest of his Q-336 note.

## Model for S554
Fable, medium effort, Fast off: the first hour is looking at pictures and re-posing by eye.
