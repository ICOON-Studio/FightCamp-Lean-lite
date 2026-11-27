# TASK RULES569 - his three rule ideas on the boxing page: one Guard action, a power switch, bars that affect each other (S569)

Kind: probe. Model: Fable 5.2 console worker (PC) - AFTER MMCTOY1 lands (it changes the same page half; build on its
result if it keeps a version, else on order.html). Discipline: boxing (Puncher's chance). Seat rules:
ops/research/WORKER_S566.md (commit by pathspec, no questions, watchdog before each table, one run at a time).

## His words (S569, verbatim)
- "a switch that sets the power that goes to your punches would be a good idea"
- "i think the bars up there all health, stamina, guard etc they all need to affect each other in a way . what if we may
  a guard 1 action like both hands up and hands do not punch at the same time and move some things into the rules
  instead of having them as actions"

## The three ideas, as rules to measure (you decide the exact numbers; one line of why each)
1. GUARD IS ONE ACTION. Today a player sets four guard switches (lead High/Low, rear High/Low) every beat. New: one
   card "Guard up" (both hands high, takes the hands' action for that moment). Everything else about the hands becomes a
   RULE, not a choice: a hand that is not punching returns to its stance guard by itself (say which line it covers and
   why - the stance: lead at the chin line, rear by the cheek), and the two hands never punch in the SAME moment.
2. THE POWER SWITCH: every punch has a mode - Normal, Full power (more damage, costs more stamina, and if it is blocked or
   countered the thrower pays: he is open in his next moment), and Feint if MMCTOY1 kept the feint as a mode. Mixed
   Martial Cards' full power (double damage for +50% stamina; countered = double damage taken and dazed) is the
   reference: ops/research/MMC_DISTANCE_S569.md, CARDREF1 s1. Not their numbers: ours, measured.
3. THE BARS AFFECT EACH OTHER (health, stamina, guard, ground): write the small table first, each link a real-fight
   reason, e.g. low stamina -> punches do less and the guard bar refills slower; an empty guard bar -> a block lets some
   damage through; low health -> stamina comes back slower; no ground left (on the ropes) -> no back off and the guard
   costs more. At most four links. Each shown on the page where the bar is (a tooltip line on the gauge: "low: your
   punches do -1").
4. COMBINED MOVES (owner S569: "would combining animations would be nice idea ?" / "drag one ontop of another to
   create the blend of them"): dropping one card on another makes ONE move in ONE moment - the step-in jab, the pull
   counter (back off + hook), the feint-and-cross - with its own cost and effect (cheaper than the two apart? harder to
   read? say why). At most four combinations, each a real boxing combination (Mixed Martial Cards' Combo cards are the
   reference). Each needs its own frame run (a render, not a blend of two runs): list them for the render queue; the
   probe can run on the rules with the nearer single run as a stand-in picture.
Versions: R1 = 1 alone; R2 = 1+2; R3 = 1+2+3; R4 = R3 + 4 (only if R3 holds its bars). Stop at the first that fails its trial and say which idea broke it.

## Do
1. Tweaks ops/research/s558_balance/rules569_r1.json (r2, r3), `src` pairs exact text; a toy page proto/twohands/rules.html
   (make_rules569.py, the way make_one.py makes one.html): the hand shows "Guard up" as a card, the power mode on a
   punch card (a toggle), the gauges' tooltips say each link. `node --check` every js.
2. Per version: its own table, trial n=12 seed 1, then n=84 mirror seeds 1 and 2, opp=0|1|2 n=84 seed 1, the feint loop.
   Control: today's page the same way (reuse a same-day control at the same n and seeds; say which).
3. page_play_test rules.html; full-size stills (beat_shot.mjs) of the hand with Guard up and a full-power punch, and of
   a gauge tooltip, opened before the commit.
4. docs/RULES569_RESULT.md: the rules as built, one table (today v R1 v R2 v R3: page bars with each red bar's number,
   clicks a beat, Guard up chosen %, full power chosen % and landed / punished %, each bar link's effect size), THREE
   plain lines for the owner. Last line `RULES569 DONE` or `RULES569 BLOCKED: <why>`. One version.js line for rules.html.

## Bars
- The page's nine bars at least as many as today's page on the same seed; mirror 40-60%.
- Fewer clicks: a beat takes fewer clicks than today (count them in the trial).
- Guard up is a choice, not a must: chosen 10-35% of beats.
- Full power is a choice and a risk: chosen 5-25% of punches; punished 30-60% of the time it is chosen.
- Each bar link changes something you can see: the gauge's effect shows up in at least 1 beat in 10 of a bout.

## Feedback loops
- Low stamina -> weaker punches -> longer bouts -> more stamina spent -> weaker: a death spiral. Cap: the stamina link
  never takes a punch below its base damage minus 1, and stamina still comes back every beat; report the stamina at the
  last bell beside today.
- Empty guard -> leaks damage -> lower health -> slower stamina -> fewer punches -> more blocking -> emptier guard: cap
  each link to one step (no link feeds another link's input twice in a beat); n=12 trial reports stoppages first (stop
  the version if they double).
- Full power -> big damage -> knockdowns: knockdowns stay 0.5-2.5 a bout.
- One-rep trial n=12 before any n=84, for every version.

## Prior research
docs/GUARDPROBE*_RESULT.md (the guard bar's history), docs/ONEACT1_RESULT.md (one action a beat: the speed numbers),
docs/MMCTOY1_RESULT.md (when it lands), ops/research/JOHN_CARDGAMES_RESEARCH_JOHN.md, ops/research/MMC_DISTANCE_S569.md.

## What would a human do?
A boxing coach: you do not think about each hand's height; your stance guards you, and you choose to shell up or to
sit down on a punch. Tired arms hit softer and drop; a man on the ropes cannot step back.

## Prefab check
Not applicable (our own rules).

## Contract
- OWNS: ops/research/s558_balance/rules569_r1.json, rules569_r2.json, rules569_r3.json,
  ops/research/s558_balance/results/rules569_*.txt, proto/twohands/tools/make_rules569.py, proto/twohands/rules.html,
  proto/twohands/version.js (one line), docs/RULES569_RESULT.md
- RED_TEST: today's order.html: 4 guard switches + up to 3 moves a beat (count the clicks), no power choice
- REGRESSION: node proto/twohands/tools/rules_test.mjs; node proto/twohands/tools/page_play_test.mjs order.html
- VISUAL: full-size stills of rules.html (Guard up card, a full-power punch, a gauge tooltip)

## Not yours
order.html and every other page, ring_ui.js / body_ui.js / hand_ui.js / strip_ui.js / clock_ui.js, balance.mjs, kick.html.
No public push. Never "Ring Switches"; the game is Puncher's chance.
