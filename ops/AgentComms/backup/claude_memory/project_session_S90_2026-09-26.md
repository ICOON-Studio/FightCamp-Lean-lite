---
name: project-session-s90-2026-09-26
description: "S90 decor step 1 shipped (7f35b94c); then M35 art ledger taken over from Maria, Tripo Pro blocks the Steam page, Cursor used until it runs out (U186 running); S91 = the front door"
metadata:
  node_type: memory
  type: project
  originSessionId: 362fcf35-440e-4cc3-b9bb-1718902461ec
  modified: 2026-09-26T18:15:35.739Z
---

S90 (2026-09-26, commit 7f35b94c): GymDecor.gd - 8 pieces (4 bought, 4 earned), wall SLOTS with the back-wall
slots nearest the clock reserved for earned pieces, one capped wall score (bought band 2.5, cap 8) feeding walk-in
reputation + morale baseline (+2 max). Earned pieces hang themselves at the title-win site and weekly. Hub WALLS
filter. D35 acted on. gym_decor_test with 6 real mutants.

Lessons:
- **A projection must not call get_championships**: it ensures/ticks the world, so get_gym_hub stopped being pure
  (gym_hub_test caught it). Read `career.simulation_world.championships` directly; tests call
  `gs.get_championships()` first.
- **U184 was NOT merged although its gate passed**: "AFTER < BEFORE" moved 1%, and a toe skate larger than the
  0.75 m/s travel measured clip foot motion, not slide - see [[feedback-metric-must-be-able-to-read-worse]].
- Rewriting roadmap.json/roster.json with json.dump changes indent + CRLF: preserve newline and indent
  (scratchpad fmt_helper pattern: load_fmt/save_fmt).
- A string search to patch a file can hit its frontmatter first - rewrite small files whole.

After the ship (same session, operator asks):
- Steam page ~3-4 weeks; blocked on ONE purchase: a month of Tripo Pro ([[project-tripo-free-plan-terms]]), then
  regenerate the 12 fighters and make the portraits from them.
- Took over Maria's M35 (art ledger, commit 1f5fd626): 9 portraits UNKNOWN -> replace; 320 Cursor-generated UI
  images need Cursor's terms quoted; 3 dead unsourced images excluded from export. M36 moot (hub decided S81).
  Trap caught: `assets/anim/audition/` holds clips FightClipBinding loads - never exclude that folder.
- Ops board looked blank on some loads; restarting the server fixed it; "server older build" label is cosmetic.
- Cursor: operator "continue using cursor until it runs out" (quota resets 10-07, on-demand must be $0). U185 gate
  missed (slide worse; kneel = foot-lock IK). U186 LANDED 7c681e50 - claims the slide gate but CHANGED the instrument (fast planted toes counted as swing): re-measure with U185 rule before merge; kneel still open; U184-186
  unmerged.

S91 = the front door (lobby, museum wall, capped walk-in funnel from G124, desk hire, physical doorways from D34).
In flight at handover: Q192 (Qwen), G124 (Grok), D36 (Dola) - all in roster.json.
