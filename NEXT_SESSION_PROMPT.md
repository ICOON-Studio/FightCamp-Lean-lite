# S447 handover (written 2026-11-13 ~08:20 at the end of S446; S445's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S447`.

## USAGE RULES (kept)
`get_usage` first; hand over at 300k context; at most TWO helpers; tell him the cost before a batch.

## HIS WORDS IN S446 (verbatim)
- "replace cursor with grokbots,arena,goose" -> done: Grok Dev = screens + look fixes, Goose = long cloud jobs, Arena = pure
  modules; CLAUDE.md roles, seat_dispatch (cursor who=()), roadmap rows, memory feedback_cursor_replaced_s446.
- "check undisputed and blood&canvas how they do it do not waste time end effort if you can get it ready" -> answered from our
  own REA notes (ops/research/POWER1_AUDIT_S446.md): B&C freezes both 0.04 s; Undisputed no freeze, follow-through 0.08-0.31 s.
- "yes merge it" (Q-207) -> POWER1 steps 2-4 merged 74a910de, 12 fight tests green, pushed.
- "give me the links what you want to buy" -> Punch Perfect (Unity, EUR 36.76 + VAT) and animo-mocap Boxing Animation Pack
  (Fab, EUR 58.57); links in ops/research/MOCAP_PACKS_S439.md. Neither is in any library we own (checked). He buys end of Nov.

## DONE IN S446 (all pushed)
- POWER1 2-4 merged after an audit; leftovers queued: POWER1B, GLOVECLASH1, JOINFIX1 (Grok Dev), FEETDIPS1 (Goose), HOOKTAKES1
  (after the mocap packs). TASK_POWER1.md restored. Films docs/mockups/s446/power1_*.png (review board).
- ASKPROBE2 collected (tools/ask_probe2.gd, docs/ASKPROBE2_RESULT.md; PR 240 closed). x1: spread ok but flat (ask vs wait even
  40/36/49 of 60), teach words differ 20/60. x1.5: DOMINANT (step up wins growth 42/60), words 31/60.
- PAGES2 sent to Grok Dev 07:40 (`gbot send --to dev`; branch grok/pages2; it skips the still - render it yourself).
- BLOCKLOOK1 finding: ops/research/TASK_BLOCKLOOK1.md (block pose unchanged by POWER1; probe staging + mc_to_block).

## NEXT, IN ORDER
1. ASKPROBE2 x1.25 RAN (S446): both bars hold at the edge (step up best for growth 36/60 = the cap; teach words 30/60 = half);
   RECORD/SAFE still mostly even. Write x1.25 into ASKFIGHT_MAP v4 + the rule module (FightLearn/AskBout; the probe's
   `step_teach` lever), tests green, then two FRESH critics (Kalli + John via seat_queue, CRITIC_PACK first) with the numbers
   as they are; 7+ both -> logic check -> one drawing for his pick.
2. PAGES2 was stale (on main as PAGES2B since S441). Grok Dev now has JOINFIX1 (ops/research/TASK_JOINFIX1.md, branch
   grok/joinfix1, ETA ~10:30): collect by diff + RESULT lines, then film the lead uppercut on the PC.
2b. ProductionCrate (his free account; he signed in in Chrome): 3 LQ crowd-flash clips with alpha in
   E:/FightCamp/incoming/productioncrate (+ LICENCE_NOTE.md: games allowed, but a personal account may not do company work -
   ask him before shipping). A helper surveyed the site for more usable assets: its list is in ops/research/PRODUCTIONCRATE_S446.md if written.
3. BLOCKLOOK1, then POWER1B / GLOVECLASH1 / JOINFIX1 briefs to Grok Dev; RESULTLOOK1.
4. His open calls: fight screen regroup + filling shout as default (stills docs/mockups/s445/hud/), voices, PA mix.

## TRAPS (S446)
- `-- nopunchrange` turns off POWER1 step 4 ONLY; a "before" film with it still carries steps 2-3 - say so on the sheet.
- roadmap.json / live_runs.json are indent=1: rewrite with json.dumps(indent=1) or the diff is the whole file.
- tools/block_meet_probe.gd stages its own pair (GAP 0.80-1.10 m): its stills are not the played fight.
- `agent_comms.py ask --attach` needs an absolute path.
