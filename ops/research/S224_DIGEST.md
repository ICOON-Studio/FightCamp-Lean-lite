# S224 DIGEST (2026-10-14) - the real-time corner approved and its engine merged, a 5-agent animation audit, Grok bots on the xAI API

## Operator, verbatim, and what was done
- Board Q-S221-3 "Approve, build it" (r61 globe/strip/HUD) -> already building; C3/C4/C5/C7 floor HUD -> FLOORHUD1 cloud Cursor #188,
  C6 street -> STREET1 Goose #189.
- Ludo r63 read + "continue" (34,835 + 12,540 chars) -> LUDO_ROUND63_VERDICT_S224.md (real-time "ticking" corner) -> Q-S221-5
  "Approve, build it" -> CORNERCLOCK1 (Arena) MERGED (PR #191, CI 3/3) -> CORNERLIVE2 cloud Cursor #192 (the card on the clock).
- Q-S221-4 "this question is old ?" -> closed (superseded); kits re-asked Q-S221-6 -> "Approve, build it" -> KITS1 cloud Qwen #190.
- "can you give ludo access to the repo ?" -> impossible directly (no GitHub connector; Ask Ludo is not in Ludo's API/MCP) ->
  LUDOCTX1 Arena (Tools/ludo_context_pack.py -> LUDO_CONTEXT_PACK.txt) RUNNING chat 01a13a2f.
- "fix this dolas window isopened" -> Dola restarted with the CDP port (it auto-starts at login without it); J68 sent.
- "dont you use xai api for grok bots ?" -> NEW: Tools/xai_ask.py + .github/workflows/xai-research.yml (repo secret XAI_API_KEY, grok-4.7,
  Responses API + web search, streaming, reply kept as an artifact + pushed to xai/<stem>). gbot is broken (roster moved to the app's pod).
- "save it in your memory how you use each agent" -> memory reference_how_to_reach_each_agent.md (+ AGENT_TOOLS.md xAI section).
- J68 corner-minute numbers: John (xAI) + Dola -> stool heart rate drops 26-35 bpm in the minute -> verdict F ruling ~0.5 bpm/s.
- "check codex progress" -> ANIMCHAIN2 had died silently at 13:19 -> relaunched; FLYFOOT2 still red (right sole).
- "ask other agents (and ludo ) and yourself audit why codex is failing on the animations ? is anything wrong with the MH models where
  is the issue ?" + "also ask codex" + "also send animation clips" + "give the video to ludo" (+ "use the ludo api ?") -> AUDIT_ANIM_S224
  pack to Codex (read-only code audit), John (xAI), Dola, Ludo r64 (video via `ludo files upload` URL + a frame grid - Ask Ludo takes ONE
  image, no video) + Claude's GLB axes check -> ANIM_AUDIT_VERDICT_S224.md -> Q-S221-7 "Approve the direction".

## The animation audit (ANIM_AUDIT_VERDICT_S224.md - read it)
MH models are fine (Unreal right-side axis convention, all 28 GLBs consistent). Ludo/John/Dola echoed my "flip the right side" guess;
Codex's code reading overruled it: the main retarget is rest-aware. Real defects: blind local mirror (FightClipMirror.gd, 178/180 deg on
MH), fixed-Euler pose layers, foot aligned by the bone line, double fold on mirrored reactions, leg/arm IK keeping wrong incoming angles,
and the native MH clips were NEVER wired (MHNATIVE1's digest claimed it). APPROVED direction: offline retarget + bake onto one MH master
skeleton, native playback, small runtime stack. Order: ANIMFIX1 mirror -> ANIMFIX2 pose layers -> ANIMFIX3 native wiring + A/B ->
OFFBAKE1 bake tool + demo palette -> ANIMSTACK1 runtime stack. Cascadeur work must end before 2026-10-27.
- ANIMCHAIN2 STOPPED 16:00 (PAIRLIVE1 ended red; ANIMSOURCE1D superseded); WIP pushed on codex/flyfoot1, codex/pairlive1, codex/animsource1.
- ANIMFIX1 r1 stopped at its gate: the 60-80 deg uppercut sole is ALREADY in the clip at sample (construction), the uppercut never visits
  the mirror; red mirror test (28 fails) committed. r2 RUNNING: A = the mirror repair proved on a mirrored role, B = uppercut stage trace.

## Merged this session (by diff)
YARDSTICK1 (Arena #187, realism yardstick, CI PASS) | CORNERCLOCK1 (Arena #191: CornerClock.gd + slip 2/8/25 + lane_ap 3, CI 3/3).
NOT run on the PC (Codex holds Godot): corner_pit_stop_test, doctor_live/referee_live/pad_chain/judge_panel (seeded hashes may move with
the slip change) - run them at the next free slot; NIGHTLY6's 4 re-pins (Goose #184) are stale (KM3B/LOCKER1B landed after) - re-pin
from PC runs; its last commit 9229cf3d reverts 439 files = DISCARD, take only dc49845e's `creation_intro` line + the re-pins.

## In flight at handover (collect next session)
- ANIMFIX1 r2 Codex gpt-6-astra high, PC, EXCLUSIVE Godot (out E:/FightCamp/wt/ANIMFIX1_out.txt, wt E:/FightCamp/wt/ANIMFIX1, codex/animfix1).
- LUDOCTX1 Arena chat 01a13a2f (arena/01a13a2f-fightcamp) | FLOORHUD1 cloud Cursor #188 | STREET1 Goose #189 | KITS1 cloud Qwen #190 |
  CORNERLIVE2 cloud Cursor #192 | GLOBE1 r2 landed cursor/issue-185 51bd6c1c (collect: --import + game-flow stills, UK must face the UK).
- Queued briefs: TASK_PROFILE2F.md (Codex after ANIMFIX), J68 done.

## Lessons (memory)
feedback_audit_before_more_fix_rounds (2 red rounds -> code audit; a digest is not code; external auditors echo the brief's hypothesis);
reference_how_to_reach_each_agent (incl. Ludo one-image limit, video via URL, the suggestion-chip trap that fired twice this session).

## HANDOFF
Working commit: see `git log -1` at ship. Next action (roadmap now): collect ANIMFIX1 r2 -> ANIMFIX2 brief; collect the cloud PRs.
