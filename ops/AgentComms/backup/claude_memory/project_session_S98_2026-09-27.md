---
name: project-session-S98-2026-09-27
description: S98 - limb damage ON by default (census KB/MMA/boxing), U189 merged, master wipe repaired (50b002ce), nightly 24 red -> Q199 bisect, Kalli/John/Maria OFF
metadata:
  type: project
---

S98 (2026-09-27): limb_damage ON by default in FightWorldLiveScreen + FightNightScreen (spars off). Census ON vs OFF,
100 bouts, inside CIs; legs reach HURT unstaged KB 6/100, MMA 28/100. U189 merged - its "0 KO" was a census bug
(read state["result"]; the verdict is FightRealtime.result(state)). D45 applied (numbered cards, "+N s over").
Master was wiped of S97 limb damage by a records commit carrying whole branch files (95c5d221), repaired 50b002ce -
see [[feedback-never-take-whole-files-from-a-branch]]. Nightly 09-27: 439/24 fails (17 newly red) - Qwen Q199 bisects.
Kalli/John/Maria are OFF on the board; operator: "u take all their tasks" - Claude did J57/K81/M37.
latest.txt starts with a BOM: a `^2026-` grep never matches (cost 90 min of waiting).
S99 = unstaged red-leg clip, collect Q199, launch C214, then fight plan as Motorsport Manager setup.
Status deck got a Sponsors slide (operator asked why sponsors were missing).
