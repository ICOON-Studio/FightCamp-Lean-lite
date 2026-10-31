# S332 - next session (written S331, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 33 is exported (Builds/, WHAT_TO_TRY.txt).
- Update 33 (S331), his Q-S294-48 "Too long to reach": the nationals' 3 months count from her England Boxing
  registration (Roster.registered_day: bouts x 4 weeks before signing; a novice registers when she signs), not from the
  day she joined our club. SeasonPath.ENTRY_CLOSE_DAY 70 (week 10, was 140), NATIONALS_GAP 21 (was 28). Lucy can enter
  in week 5 (was 14); the national final is week 18 (was 29).
Digest: Game Godot/research/S331_DIGEST.md. Stills: S331_stills/.

1. Board Q-S294-47 (update 29), 49 (update 31), 50 (update 32 look), 51 (update 33). Act on them first.
2. If he says yes to the look (Q-S294-50): GYM, MONEY, FIGHTS and the fighter page as pictures with the same parts
   (FighterTile rings, WeekStrip, SeasonRoad, Bracket, CashChart, NeedRing). One page per commit; before/after stills with
   tools/pages_now_still.gd; keep every script under 500 lines.
   If the debut is too costly (Q-S294-49): ProDebut.FAMILY / PER_MEMBER up, or she pays her own scans.
   If update 33 is still too long / too easy (Q-S294-51): SeasonPath.ENTRY_CLOSE_DAY / NATIONALS_GAP.
3. With no answers: INSIDEMISS1 (two close-range punches land 15-20 cm to the side) on game-camera stills.
4. Export, WHAT_TO_TRY, stills, board question with --attach, review_add, Miro P0 + part cards (not moved in S331).

Traps: Career.seed is randi() per career - any test that rolls dice fixes c.seed; PowerShell Set-Content utf8 writes a
BOM; a test finds modal nodes via main.modal_node(); roadmap.json is written with indent=1 (indent=2 rewrites the whole
file); champs_test's day numbers follow SeasonPath's calendar (close 70, semi 84, final 91, nationals 112).
