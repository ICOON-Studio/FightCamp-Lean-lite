# S340 - next session (written S339, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S339 shipped update 41: the coach's plan in the fight (scripts/rules/PlanFight.gd; LiveRound/BoutNight wiring), the plan
board on her page ("Fight plan", saved as f["arrows"]), the corner's PLAN row (one arrow a round), the arrow named in the
ring and the words view; Holly Price / Ellie Ward / Jade Cooper in the region; the body view stands relaxed (C155).
Digest: Game\Godot\research\S339_DIGEST.md.

OPERATOR RULE S338: "keep all agents working on animations and you work on the mechanics and ui".

1. AGENTS FIRST (animation only, every seat busy, never two seats on one clip):
   - Cursor -> FIGHTCARD1: the 3D ring stages the plan's card. LiveRound records rec["at"] per exchange (outside / long /
     mid / inside / clinch / own_ropes / opp_ropes / corner). On own_ropes her back goes to the ropes, on opp_ropes/corner
     the opponent's; the gap follows the card's range_m (StrikeMap.CARDS). RingPlace.gd / RangeBreath / ExchangeBeats.
     Red test first: a beat plan for an own_ropes exchange leaves her pelvis within ROPE_LEAN_M of the ropes. Still:
     tools/fight3d_play.gd (p03b showed "Plan: Pivot off the ropes" with both women mid-ring).
   - Qwen/Grok -> TIECLIPS1: clips for the 3 tie-up answers without one (Go-behind x2, Shuck).
   - Goose/cloud -> PADWORK1: pad work on the Training page (coach with mitts + boxer combos; MoveClips is the table) -
     ask the fight-stills session (ANIMCLOUD1 owner) first.
2. CLAUDE MECHANICS: OPPPLAN1 - the opponent's corner plans too (a rival's plan by her style; a good plan is then an answer,
   not a free edge). Measure with tests/plan_bout_test.gd before and after (good 0.541 / none 0.499 / bad 0.495 today).
   Then PLANPADS1 - camp weeks drill a few plan arrows (the "untrained 80%" combinations reach full rate).
3. The operator plays update 41 (Lucy's page > Fight plan > Save > fight > the corner's PLAN row).
