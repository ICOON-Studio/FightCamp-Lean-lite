# S557 handover (written 2026-11-25, S556 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. The result pages of S556, NOT GREEN lists
first: `docs/RINGSWITCH_S556.md` (the page), `docs/RINGSWITCH_SOUTHPAW_S556.md`, `docs/BODYJAB1_RESULT.md`.

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE, AND THE ORDER VERSION IS THE PAGE (owner S553: "i think we should focus more
  on the RingSwitches"; S555: "first off i want version with theorder of actions"). `proto/twohands/order.html` is the
  hand-edited source. `switch.html` is the old version without order: do not build on it.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555: "vs the jabber you win very easy , all
  your rear hands land easy , need better balance , i want this slice to be perfectly balance to move on (always have in
  scope other arts that will be added and knees and elbows)"). A CHANGE IS FIRST TRIED WITHOUT TOUCHING THE PAGE
  (`tweak=<file.json>`, examples in ops/research/s555_balance and s556_balance; `tweak_check.mjs <file>` says whether it
  still fits the page). AFTER ANY RULE OR NUMBER CHANGE ON THE PAGE: `node proto/twohands/tools/balance.mjs table`
  (about 5 minutes, writes vtable.json, which the page loads), then `node proto/twohands/tools/balance.mjs play who=mix
  opp=mirror n=84` (the nine bars; `seed=2` for a second set - one set is +-10 points), then
  `node proto/twohands/tools/rules_test.mjs` (34 tests) and `node proto/twohands/tools/page_parse.mjs order.html`.
- ## METHOD - THE FIGHT MUST BE SEEN, SIDE VIEW, BOTH MEN CHEST TO THE CAMERA (owner S553: "Yes, side view"). Every render
  takes `south=blue`. A fall never without its punch. A held hand shows its arm and sits where it guards. Ranges drawn.
- ## METHOD - THE SEATS' IDEAS ARE USED AND REPORTED (owner S554: "what happenned with the brainstorming from other
  agents ?"). Every answer a seat sends is read the session it lands; he is told what each said, what was built, what not.
- HOW HE WORKS ON THIS GAME: he plays the page in Chrome while the session runs and writes what is wrong within minutes.
  Show early; answer his question first, then fix what made him ask.
- A PAGE HE PLAYS IN CHROME NEEDS A SERVER IN A TERMINAL TAB (`python proto/cardgame/serve.py 8797 twohands`; curl first).
  It was up all S556: http://127.0.0.1:8797/order.html
- DO NOT EDIT order.html (or balance.mjs) WHILE A balance.mjs RUN IS GOING: its workers read both as they start.
- A script with an apostrophe or a backslash goes in a FILE (the Write tool), never a heredoc. `cd /e/FightCamp/Lean &&
  ...` in every command (a `cd` carries to the next call). Every Godot start goes through
  `python ops/Tools/godot_slot.py run --who <id> -- ...`.
- HIS GAME FIRST: `Get-Process ArcheAgeChronicles` before any render. AGENTS ONLY IN THE CONSOLE.
- FIGHT ANIMATION: v2 only, no new correction layer in scripts/fight3d; an authored take baked by a tool is the route.

## What S556 left
- **The page** (commit 9a8e2a0f5): the body jab with its own pictures; an even round goes to the man who backed off
  less; health 18 (the opponents 16 / 21 / 18). Two equal men who play well: 8 of 9 bars on two sets of 84 bouts (16%
  stopped, 2.25 knockdowns, 7.5% draws, Inside / Mid / Long 32 / 35 / 33%); the failing bar is the old one (the jab lands
  73%, the body jab 69%). The measuring player wins 54 / 51 / 40% against the three. One beat played in the browser by me.
  HE HAS NOT PLAYED IT.
- **Moving costs breath** (both seats' other ask): measured, NOT on the page - the men stop moving (feet stay 47% of
  beats, was 27%), 7 of 9 bars.
- **The southpaw**: five rule versions measured, none passes (best 6 of 9), none matches John's numbers (the rear
  straight thrown 25 to 40% more, the jab landing half as often). Why: the rear hand held high already stops the hook
  and the overhand; with the cross it stops three big punches and the lead hand held high is left with the jab alone
  (held in 2% of beats). NOTHING BUILT. The design question is with Kalli: SQ334,
  `ops/research/RINGSWITCH_SOUTHPAW2_BRIEF.md` -> `RINGSWITCH_SOUTHPAW2_BRIEF_KALLI.md`.
- **The body jab take** (`pro_body_jab`, commit d447ba3a5): `tools/pics2d_bodycross_bake.gd -- take=jab ...` (the tool
  now takes the punching arm as a setting; the body cross bakes unchanged). Its clip table row was added BY HAND.
- **Export**: Builds/ rebuilt in S556 (it carries S548's two game changes; WHAT_TO_TRY.txt X and Y).

## FIRST
-1. ZIVAFIX1: WHAT ZIVA'S PLAYTEST ASKS FOR (owner: "Can ziva play test it and judge it on fun?"). Collected and checked
   in S556: `ops/research/ZIVAPLAY1_REPORT.md` (my check is its first block), its drawing `ops/research/ZIVAPLAY1_TEN.html`
   (picture: ops/previews/s556_zivaplay/zivaplay1_ten.png, on the map). FUN 6, DEPTH 7, CLARITY 6, VARIETY 6. Its verdict:
   the ORDER is the game's original idea and it works; the fun between those moments is missing because the main guess
   (which line is open) is blind.
   a. PAGE, words and display only (no rule changes, so no table): HIS LAST THREE BEATS shown before you choose (his
      holds and what he threw; the page has `F[1].hist`); "stamina bar shorter" says FOR THE REST OF THE BOUT, and the
      floor (4); "one more knockdown ends it" beside the health bar of a man down twice; one line on why points differ
      from the health shown (points come from the punch's own health: 2 for 3 or more, 1 otherwise; a counter adds health,
      not points). Then rules_test, page_parse, one bout played in the browser.
   b. ON THE BALANCE TOOL, each as a tweak first: a block costs the BLOCKER guard (ties to his open call on the guard bar:
      Kalli cut it, John rebuild it - this is a third answer, tell him); one honest punch at Long (S555 measured the cross
      at Long: the jab dies - try the step in cheaper when it answers a back off instead); opponents that do not play the
      identical beat three times running (the plain beats of `skill`: vary their order).
   c. `play_cli.mjs` refuses a plan the stamina cannot pay and waits: offer the plan without its dearest switch instead.
   d. A fun playtest belongs after every rule change: start Ziva (memory: breath-in-reserve-ziva-plays-s556), new chat,
      the brief pattern ops/research/TASK_ZIVAPLAY1.md. It took Ziva about an hour for nine bouts.
0. KALLI'S COVER TABLE for the open stance, if it has landed (`start` prints SEAT ANSWERS). Write it as a tweak
   (pattern: `ops/research/s556_balance/southpaw_v3_john.json` - `ACT.<id>.line` gives a punch its own line, the `src`
   pair on the cover line says which held hand covers it), `tweak_check.mjs`, then
   `N=84 sh proto/twohands/tools/balance_batch.sh <out_dir> <file>` (5 minutes a version). Tell him against the nine
   bars AND John's two facts (the cross thrown MORE than 3.8 a bout, the jab landing well under 73%). Build only at 8
   bars or more; the build is "The Southpaw", a fourth opponent whose bouts use the open table (the cover rule keyed by
   the stance pairing), with mirrored pictures of the red man - tell him the picture cost first (about 60 runs, 25
   minutes of rendering, and the clinch picture breaks with a mirrored man: docs/HOLDTAKES1_RESULT.md).
1. HIS PLAY on the page. If an opponent is too hard or too easy the knob is `skill` in OPPS (0.5 to 1.0); re-measure
   with `balance.mjs play who=sensible opp=0,1,2 n=84`. The Body Snatcher stops the measuring player in 40% of bouts:
   the first one to watch.
2. THE LOOK-AHEAD DOES NOT KNOW THE GROUND RULE: the solved mix backs off as before, so against a human who plays for
   level rounds the opponents give ground too cheaply. Either a term in `worth()` for the last beats of a level round, or
   raise `W.ropes` and re-measure. Measure before and after with the mirror and the three opponents.
3. THE BODY JAB'S AND THE BODY CROSS'S BLOCKED AND MISSED PICTURES are at chest height (the picture tool sends a blocked
   body punch onto the cover-up; `mc_block` holds its elbows 0.44-0.47 m over the rib target). An authored LOW cover
   (elbow down on the ribs) is the fix: the animation item of S557. Name the study and the clip it follows (owner S537).
4. The rest of the seats' list, each measured on the tool before anything is built: the lead uppercut beats a clinch in
   the same moment (both seats), HURT, Kalli's CIRCLE feet switch (needs pictures).

## Then
- The body hook is the least used punch now (4% of beats; the bar is 3%): watch it after any change.
- The clinch when HE ties up (a head inside a head with blue mirrored; docs/HOLDTAKES1_RESULT.md).
- Both REAR hooks that miss are still wide (0.30, 0.34 m). The uppercut picture he sent without words in S552.
- The page's long how-to text: he likes little text; move it to hovers.
- The guard bar: Kalli says cut it, John rebuilds it on stamina. Still his call.
- THE CLIP TABLE IS NOT WHAT ONE TOOL WRITES: a full `tools/clip_census.gd` run today changes eight rows
  (pro_body_cross's contact goes to 0.35 s, pro_right_cross moves, the gut-shot reactions lose the fold fields of
  `tools/bodyreact2_bake.gd`). Add or refresh ONE row by hand until the census keeps those (docs/BODYJAB1_RESULT.md).

## Not touched this session
MATCHBOTS2 hooks on disk, uncommitted (tests/matchmaking_bots_test.gd is modified in the working tree: not mine); the
05:00 run of 2026-11-25: no new red (matchmaking_bots is the old one; dues_card was fixed in S555 and ring_steps by the
05:00 review, both after that run). Dola's two queued briefs (SQ324, SQ327) cannot leave
the queue: her app runs without its debug port.

## His words after the handover (S556)
- "Maybe breath can be used to put a limit on movements if that becomes an issue": moving costs breath stays OFF the
  page and in reserve (`ops/research/s556_balance/breath.json`); bring it back, measured, only if moving becomes a problem.
- "Can ziva play test it and judge it on fun?": yes, see FIRST -1.
- The southpaw, asked "wait for Kalli's cover table, or build one of the measured versions anyway?": "Wait for Kalli".
  SETTLED: nothing of the southpaw is built before her table is measured (FIRST 0).

## Waiting on the owner
His play on the page with the body jab.
The guard bar: cut or rebuild. The rest of his Q-336 note ("thecoaches should have").

## Model for S557
Fable, medium effort, Fast off: his play decides the first hour; a low cover take is authored and judged by eye.
