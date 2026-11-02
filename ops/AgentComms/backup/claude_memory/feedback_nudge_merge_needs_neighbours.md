---
name: nudge-merge-needs-neighbours
description: Before merging a constant nudge in a shared engine file (FightRealtime), run the pinned-seed neighbours (judge_panel, fight_contact_stop, grapple_naming, result_screen_why) - PR #47 broke four
metadata:
  type: feedback
---

S163: Arena's PR #47 (MMA footwork speed + RNC finish rate, 4 lines in FightRealtime.gd) fixed its 2 target tests, but moved the shared RNG outcomes and broke fight_contact_stop, grapple_naming_contract, judge_panel and result_screen_why (nightly red). I had run only the two target tests. Reverted.

**Why:** these tests pin seeds or measured values; any change that shifts the RNG sequence moves them. An Arena PR cannot run Godot, so nobody saw it.
**How to apply:** for any PR touching FightRealtime/FightIntent constants, run `run_tests.py --only` for judge_panel, fight_contact_stop, grapple_naming_contract, result_screen_why, fight_ring_position, fight_strike_whole BEFORE `gh pr merge`; put that list in the brief's acceptance. See [[feedback_defects_live_where_agents_meet]].
