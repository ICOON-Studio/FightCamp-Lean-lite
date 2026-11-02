# TASK MEMBERS1A - paying members: archetypes, T1 club economics, member-to-fighter pipeline (pure + data + test) (S197)
Model: cloud Codex (issue label `codex`) - pure module + JSON + headless test; no LFS, no UI, no edits to existing files.
Operator approved Ludo round 32 (board Q-S196-2: "amazing, approve all ...") incl. C "members and the living gym".
Spec: research/LUDO_ROUND32_S197.txt - "4.1 Member Archetypes (JSON Data Structure)", "4.2 Facility Economics (540 m2 Hall - Tier 1
Balance Sheet)", "4.4 How a Member Becomes a Fighter (The Talent Pipeline)". Verdict: research/LUDO_ROUND32_VERDICT_S197.md section C.
Build NEW files only:
1. Godot/assets/data/members.json - the archetypes exactly as Ludo's JSON (fee, visit hours, churn, preferred areas/stations), the T1 balance
   sheet numbers, and the pipeline (triggers, probabilities, the numbers 4.4 gives). Capacity per hour must respect
   Godot/assets/data/club_capacity_rules.json (60 members at once for the T1 hall - read it, do not copy it).
2. Godot/scripts/rules/Members.gd - extends RefCounted, class_name Members, pure static, loads + caches like Godot/scripts/rules/CareerWear.gd.
   API: `archetypes() -> Array`; `monthly(members: Dictionary) -> Dictionary` (revenue, churn expected, by archetype);
   `hourly_load(members: Dictionary, hour: int) -> int` (people on the floor at that hour); `prospect_chance(member: Dictionary,
   gym: Dictionary) -> float` (4.4 pipeline); no RNG inside.
3. Godot/tests/members_test.gd - extends SceneTree, prints `MEMBERS total=N fails=M`, quit(1) on fail: archetype numbers match Ludo, the T1
   balance sheet sums, peak hour load never above the capacity rule, pipeline chance bounded 0..1 and rises with the factors 4.4 names.
   3 mutants in the PR body that each fail.
Gate (CI): `godot --headless --path Godot --script tests/members_test.gd` -> exit 0, fails=0, no SCRIPT ERROR. Typed GDScript, tabs.
Branch codex/issue-<n>, open the PR, never merge, never master.
