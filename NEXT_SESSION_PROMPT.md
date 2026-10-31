# S330 - next session (written S329, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 31 is exported (Builds/, WHAT_TO_TRY.txt).
- The pro debut costs money (John J-PRODEBUT1): scripts/rules/ProDebut.gd (Qwen, pure) - licence $230, first-licence
  scans $875, trainer licence $140 (c.coach["pro_licence"]); 100 tickets at $50, break-even 60, her half past it, the gym
  keeps 25 % (Roster.GYM_SHARE, was 0.35). Tickets = family 20 + members/2 + 2 per amateur win + 10 per title.
  Roster.turn_pro pays the costs and books the debut with "tickets": true; BoutNight._finish pays the gym's share of her
  ticket half (members before the result); flat purse from bout 2. ProOffer shows TicketBar + THE GYM PAYS NOW.
- WORLD > Nationals as pictures after the operator's C150 note: scripts/ui/NationalsView.gd + SeasonRoad / NeedRing /
  Bracket (custom _draw controls). Finished road stays until next season's entries open.
- Championship result ribbon no longer shows a $450 cut (BoutNight m["club_cut"]).
- TestJump "pro" + board button "Test: the pro offer and her debut (update 31)" (task FightCamp Play test pro).
Digest: Game Godot/research/S329_DIGEST.md. Stills: Game Godot/research/S329_stills/.

1. Board Q-S294-47 (update 29), Q-S294-48 (update 30), Q-S294-49 (update 31) - act on his verdicts first. If he says
   the debut is too costly: the levers are ProDebut.FAMILY / PER_MEMBER and the gym paying only the licence (scans by her).
2. MENULOOK1: management screens as pictures - his C150 on a page of rows says rows read flat. HOME and FIGHTERS first,
   the way Nationals now is (custom _draw controls: road, rings, bars), stills on the hidden desktop, board question.
3. Export, WHAT_TO_TRY, stills, board question with --attach, review_add, Miro P0 + part cards.

Traps: PowerShell Set-Content -Encoding utf8 writes a BOM (broke nothing in Godot, but strip it from .sh files); a test
looks for modal nodes under main.modal_node(), not main._shell; editing a test while run_tests.sh runs makes it red -
rerun alone (tools/run_some.sh <tests>); a scripted career that books bouts must start a camp (Lucy 62.6 vs 61.2 kg).
