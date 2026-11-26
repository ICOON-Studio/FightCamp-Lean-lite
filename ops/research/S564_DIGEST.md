# S564 digest (2026-11-26, Opus 5.5)

## His words this session (quoted)
- "grokbots are back" -> John and Kalli nudged on their unanswered briefs (both answered within the hour: SQ337, SQ338);
  a new design brief for Kalli and Dola: Long is a corridor (SQ339, SQ340).

## His question (S563) - the tells - round 2 collected
"do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ?"
| Seat | Round | Verdict | Scores (tells) |
|---|---|---|---|
| Arena | ALLPLAY2B (v2) | fixes work; the Slugger lied 2 of 18 (a lookup table); teach the bluff cap | fun 7, depth 8, clarity 8, variety 7 |
| Ziva | ALLPLAY2B (v2) | 3 of its 10 fixes landed; a fake shoulder hid a body cross + lead uppercut for 5 ("the bluff was bigger than the promise") | 8.3 overall (v1 7.3) |
| Antigravity | ALLPLAY2 (v1) | ONE body tell (5 of 5 testers now); 26 of 27 tells true; feint -> overhand landed 12 of 13 | 7.5 fun with tells |
| TELLS2M (bots) | v2, n=12 trial | stopped on its rule: the control already wins 67-83% v the page's men; the lie rate followed the player (41-46% v a strong bot, 10% v a careful one) | - |

## Done (commits on main)
- 360fad064 collect ALLPLAY2B Arena; RESUME_S564_RENDERS (the INSIDE1 + GLIDE2 render worker, terminal tab renders564).
- 62aa327cc TELLS VERSION 3 (`play_cli.mjs ... tells=3`, tells.mjs LIES3 / CAP3 / LEGEND3): a fake only when his real beat
  does less damage than the smallest punch the cue promises; at most 2 fakes a round, never two running; a second
  condition of his own state; the fake line names the rule; the legend says a quiet guard does not cover his lead hand.
  Versions 1 and 2 unchanged (two playtests were running on them). probe_tells.mjs `v=3`. Collected TELLS2M + Ziva.
- 20aab7e2 the Body Snatcher's second rule = the beat after he threw a body punch ('behind on points' held on 5% v a
  careful player). Rates (`tell_rates.mjs me=ai|guard`, new cautious-player mode):
  | Man | v2 (AI / careful) | v3 (AI / careful) |
  |---|---|---|
  | Jabber | 29 / 24% | 19 / 15% |
  | Slugger | 27 / 10% | 24 / 24% |
  | Body Snatcher | 13 / 10% | 17 / 11% |
- TELLS3M (Arena) launched on v3 with the bars restated against the control (BOT 1 at most BOT 0 + 5; BOT 2 at least
  BOT 1 + 10 or 2 health less taken; fakes 15-30%; bluff share 100%). Told mid-run to merge main for the Body Snatcher change.
- TASK_TELLS2PAGE (gated on TELLS3M + his yes + the renders): the tell as a pose of HIS body (anticipation frames of
  the real move), the word in the ring's corner badge, rules above the page mark (one source), balance unchanged.
- TASK_KDPIC1: the knockdown kept inside the ring; the overhand gets its own take - none of clip_db's 186 takes is one
  (every rear-hook take is a hook); our archives, then Ludo for one hour.
- CLINCHFIX2 collected (DONE, none): P2 brings the loop to 15-18% but the clinch and push off go dead (2-3%) and knockdowns
  2.7-2.8 - 6 of 9. Found the lever: order.html line 228 records only PUNCHING beats in the habit history, so his habit
  read never sees a clinch. CLINCHFIX3 (Arena): H1 a clinch enters the history, H2 + clinch +1 stamina. Trial n=12 on the
  PC: the loop 58 / 33 / 42% v 38 / 63 / 70%.
- AIEMPTY1 (Arena): count his empty beats (push off after his back off, a feint with no punch after it, step in Inside
  with no ground, back off at Long with no punch) and filter them from his plain beats only, his strength within 5 points.
- Antigravity's report and logs under ops/research/allplay2/antigravity/; John SQ337 (UFC comebacks: a dropped man who
  fights on wins 34.4% of 910; dropped twice 7%; nobody after three), Kalli SQ338 (three kick designs; build first "moving
  feet beat the low kick").
- Map: 41 stale NOW cards dropped; roadmap now / next / plan; live_runs current.

## Running at the stage end
TELLS3M arena/181a4c7c, KDHEAL1 arena/836987cb (KD0 control 8 of 9, comeback 19%; KD3 [3,2] dropped at 75% stoppages),
MOMENTGAP1 arena/4bdf9ebc (trial: a free wait picked in ~70% of beats, 5 of 9), CLINCHFIX3 arena/67e7800b, AIEMPTY1
arena/f889f281, JABLAND1 arena/ba10e2bf (b 8 of 9 but the jab and overhand dead; c 7 of 9 seed 1), KICKFIX3
arena/c178d87d (E2 trial 5 of 9), PROGP2 arena/15b7ab01, HEADPULL1 arena/397eb67a (run 1: 7 of 9). Render worker
renders564 (INSIDE1 probe, then GLIDE2 renders, then INSIDE1 re-render). Kalli SQ339, Dola SQ340.

## Not done / open
- 518 changed + 1262 new picture files in proto/twohands/img/anim from earlier sessions, never committed (the pages he plays
  load them from disk); left for the render workers, who commit only their own runs.
- BOUNCE1 and KDPIC1 wait for the render worker (one render at a time).
- Ziva's fixes not taken yet: split "back off" from "clinch" in the back-foot cue; the liar notices he is read; the
  fake's cost surviving the bell. Antigravity's: feint counterplay (JABLAND1 measures the overhand), "a landed jab stops a
  step in" (a Long-range idea - see Kalli/Dola SQ339/340).
- No export: no game code changed.
