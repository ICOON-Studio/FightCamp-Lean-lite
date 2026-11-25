# S556 handover (written 2026-11-25, S555 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. The result page of S555, NOT GREEN list first:
`docs/RINGSWITCH_BALANCE_S555.md`.

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE, AND THE ORDER VERSION IS THE PAGE (owner S553: "i think we should focus more
  on the RingSwitches"; S555: "first off i want version with theorder of actions"). `proto/twohands/order.html` is the
  hand-edited source. Its generator is gone; `switch.html` is the old version without order: do not build on it.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555: "vs the jabber you win very easy , all
  your rear hands land easy , need better balance , i want this slice to be perfectly balance to move on (always have in
  scope other arts that will be added and knees and elbows)"). AFTER ANY RULE OR NUMBER CHANGE ON THE PAGE:
  `node proto/twohands/tools/balance.mjs table` (about 7 minutes, writes vtable.json, which the page loads), then
  `node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=84` (prints the nine bars), then
  `node proto/twohands/tools/rules_test.mjs` (30 tests). A change is TRIED without touching the page: `tweak=<file.json>`
  (examples in ops/research/s555_balance/). A quick look may reuse a nearby table (`table=<f>`, 2 minutes); the answer that
  goes on the page gets its own table.
- ## METHOD - THE FIGHT MUST BE SEEN, SIDE VIEW, BOTH MEN CHEST TO THE CAMERA (owner S553: "Yes, side view"). Every render
  takes `south=blue`. A fall never without its punch. A held hand shows its arm and sits where it guards. Ranges drawn.
- ## METHOD - THE SEATS' IDEAS ARE USED AND REPORTED (owner S554: "what happenned with the brainstorming from other
  agents ?"). Every answer a seat sends is read the session it lands; he is told what each said, what was built, what not.
- HOW HE WORKS ON THIS GAME: he plays the page in Chrome while the session runs and writes what is wrong within minutes
  (S555: three messages in the first hour). Show early; answer his question first, then fix what made him ask.
- A PAGE HE PLAYS IN CHROME NEEDS A SERVER IN A TERMINAL TAB (`python proto/cardgame/serve.py 8797 twohands`; curl first).
  It was up all S555: http://127.0.0.1:8797/order.html
- DO NOT EDIT order.html WHILE A balance.mjs RUN IS GOING: its workers read the page as they start.
- A script with an apostrophe goes in a FILE (the Write tool), never a heredoc. `cd /e/FightCamp/Lean && ...` in every
  command (a `cd` carries to the next call). Every Godot start goes through `python ops/Tools/godot_slot.py run --who <id> -- ...`.
- HIS GAME FIRST: `Get-Process ArcheAgeChronicles` before any render. AGENTS ONLY IN THE CONSOLE.
- FIGHT ANIMATION: v2 only, no new correction layer in scripts/fight3d; an authored take baked by a tool is the route.

## What S555 left on the page (played in the browser by me for one beat, NOT by him)
- A blocked punch says whose hand and why: "blocked: your lead hand was still up (its Lead hook comes in moment 2)".
- The opponents are not scripts: each beat the page solves the guessing game and he draws from the best mix, leaning to
  his style, with a SKILL (the share of beats he plays that mix: Jabber 0.52, Slugger 0.58, Body Snatcher 0.78).
- Five rules: a landed jab no longer keeps him out; a step in beats a back off in the same moment; every back off gives
  ground; the clinch is Inside only and gives 2; the cross and body cross reach Mid and Inside.
- Numbers: health 17, up on 6 then 4; lead uppercut 2 stamina / 3 health / the hooks' speed; lead hook as fast as the jab.
- Measured: two equal men who play well box Inside / Mid / Long 32 / 35 / 33% (this morning 6 / 19 / 75), stoppages 20%,
  draws 12%, 8 of 9 bars (the jab lands 72%). The player who answers the man's last beat wins 44 / 56 / 42% against the
  three (this morning 100 / 81 / 72), random clicking 11 / 7 / 9%, the best-mix player 81 / 69 / 62%.

## After the handover, the same day (he played and asked; all on the page, pushed)
- "what pushes means ? how is done ?": a push line says what it is and why it did nothing; his plain beats never shove
  at nothing. "can you make it so i can drag and fix the order ?": the order chips are dragged (a click still moves one
  earlier). "when beaten to the punch happens ?": the line names the faster punch; every switch shows its punch's speed
  (fast / medium / slow). "can you add tooltips for these rules when they apply": hover or tap a row of the beat
  (`ruleOf`). "visuals for the player to understand which is his leading hand ?": a drawing on each hand's header with
  that glove lit. NOT done there: the gloves are not marked on the fight picture itself (pictures carry no glove
  positions except at contact). 32 rule tests.
- STANCES (his question: "dont we need stances ? switching lead hands , does that fit or it make things brake and
  complicated ?"). My answer, which he took ("yes prepare this for next session"): stance is a TRAIT of a fighter (a
  southpaw opponent first), not a switch flipped during a beat (a fourth decision a beat, four stance pairings for the
  balance, every picture mirrored). NOTHING IS MEASURED YET.

## FIRST
0. THE SOUTHPAW, MEASURED (he said yes). Orthodox against southpaw is the OPEN stance, and both men are in it, so the
   mirror bout is that game. Two variants are ready to run, nothing on the page is touched:
   `ops/research/s555_balance/southpaw_v1.json` (the rear straights - cross and body cross - come down the middle past
   the lead hand: the REAR hand stops them, high the cross, low the body cross) and `southpaw_v2.json` (v1, and the lead
   hands are in each other's way: a lead hand held LOW stops the jab too).
   a. `node proto/twohands/tools/tweak_check.mjs ops/research/s555_balance/southpaw_v1.json southpaw` (the tweak's text
      pairs still fit the page? it prints PASS).
   b. For each: `node proto/twohands/tools/balance.mjs table tweak=<f> out=<scratch>/sp1.vt.json` (7 to 8 minutes), then
      `node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=84 tweak=<f> table=<scratch>/sp1.vt.json`
      (or both in one go: `N=84 sh proto/twohands/tools/balance_batch.sh <scratch_dir> <f1> <f2>`).
   c. Report to him against the same nine bars, beside today's closed-stance numbers (docs/RINGSWITCH_BALANCE_S555.md):
      does the open stance stay balanced, and does it ASK SOMETHING ELSE (which hand is held where, how often the cross
      and the jab are thrown and land)? If it only shifts numbers, say so: then a southpaw is not worth its pictures.
   d. Only if it passes and differs: the build is a fourth opponent "The Southpaw" whose bouts use the open table (the
      cover rule keyed by the stance pairing - write it that way from the start, kicks will need the same key), with
      `covers()`, THREAT / STOPS / YOURS and `ruleOf` saying the open-stance words, and MIRRORED PICTURES of the red man
      (the mirrored man is what breaks the clinch picture: docs/HOLDTAKES1_RESULT.md). The picture cost is the real price;
      tell him that number before building. Real-boxing grounding to name in the report (owner S537): ask John for the
      sourced numbers on orthodox v southpaw (jab and rear-straight land rates) - queue it at session start.
1. HIS PLAY on the balanced page. If he says an opponent is too hard or too easy, the knob is `skill` in OPPS (0.5 to
   1.0: the simple player's wins fall from about 60% to about 25%); re-measure with
   `balance.mjs play who=sensible opp=0,1,2 n=84`.
2. THE TWO CHANGES BOTH SEATS ASKED FOR, measured on the tool before anything is built (table in the result page):
   MOVING COSTS BREATH (a held hand gives its +1 stamina only on a beat the feet stayed) and AN EVEN ROUND GOES TO THE MAN
   WHO GAVE LESS GROUND. Then, one seat each or both: the lead uppercut beats a clinch in the same moment, HURT, Kalli's
   "back off escapes hooks, not straights" with a CIRCLE feet switch (a new switch needs its pictures).
3. THE BODY JAB. Measured on the balanced rules it is better still (draws 12% -> 4%, the jab and the body jab each 12% of
   beats, so Long gets a real guess) but it has no picture. Author its take (pattern `tools/pics2d_bodycross_bake.gd`,
   496 lines, built around the RIGHT arm: either make its arm and source a parameter and prove the body cross bakes
   unchanged, or a second tool; name the study and clip it follows, owner S537), family `body_jab` in tools/pics2d_set.gd
   (499 lines: the entry must replace a comment line), render its runs, then
   `python ops/research/s555_balance/apply_rules_bjab_patch.py bjab` IS NOT RUNNABLE AS IS (it holds this session's whole
   rule patch): take only its `if BJAB:` block, add the run names to anim_check.mjs, rebuild the table, re-measure.
   A baked `mc_Box1_M3_Body_Jab.res` is loaded by the game as `pro_body_jab` by itself (FightClips.pro_stems): check
   clip census and ring_steps tests after baking.

## Then
- The clinch when HE ties up (a head inside a head with blue mirrored; docs/HOLDTAKES1_RESULT.md).
- Both REAR hooks that miss are still wide (0.30, 0.34 m). The uppercut picture he sent without words in S552.
- The page's long how-to text (five lines of rules at the start): he likes little text; move it to hovers.
- The guard bar: Kalli says cut it, John rebuilds it on stamina. Still his call (it is on the page, nearly idle).
- The measuring tools `probe_rules.mjs`, `probe_body_jab*.mjs`, `probe_jab_keep.mjs`, `probe_order_guard.mjs` predate the
  solved opponents: each opponent beat is now a full solve, so they are slow; `balance.mjs play` replaces them.

## Not touched this session
MATCHBOTS2 hooks on disk, uncommitted (tests/matchmaking_bots_test.gd is modified in the working tree: not mine); the
05:00 reds left: matchmaking_bots (old), ring_steps fixed by the 05:00 review, dues_card fixed in S555. NO EXPORT SINCE
S547: S555 changed no game file (one test, the browser toy and its tools). Dola's two queued briefs (SQ324, SQ327) never
left the queue. Animation: no take was authored this session - the body jab take is the animation item of S556.

## Waiting on the owner
His play on the balanced page. The guard bar: cut or rebuild. The rest of his Q-336 note ("thecoaches should have").

## Model for S556
Fable, medium effort, Fast off: his play decides the first hour; the body jab is an authored take judged by eye.
