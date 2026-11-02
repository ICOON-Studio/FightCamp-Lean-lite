---
name: project-session-s218
description: "S218 2026-10-13 - crash recovery, story mode 2 of 3 builds, 6 nightly reds fixed, Grok Dev coding seat live, lessons on collecting agent fixes"
metadata:
  node_type: memory
  type: project
  originSessionId: 9d3decfa-4161-4cef-87b2-2a35b32f351f
  modified: 2026-10-13T13:33:43.878Z
---

Built: story mode rules + New Career/Settings screens + Mara Solano first hour (STORYPARITY1 left, needs Ludo numbers); Recovery
Rate live + fight-end fixes; floor slots; body nearest size; icons R4; Mixamo batch 2; pure modules from Arena. Digest S218_DIGEST.md.

Lessons:
- Grok Dev (Grok Bot app chat "Grok Dev") is a real coding seat: own Linux box, Godot 4.7.2 installed, clones without LFS, pushes
  grok/* and opens PRs. Drive it through the app (gbot CLI broken by app 0.70.2); a token needs Contents AND Pull requests write.
- Do not "correct" an agent's fix on principle before running its tests: I removed Qwen's free-slot fallback and broke
  equip_slots_test - slots are the capacity authority. Read the design, then judge.
- A test that merges FightRealtime.DEMO_SWITCHES changes outcomes whenever a switch joins that list (recovery_rate): new reds there
  can be latent defects exposed, not the new switch's fault (here: doctor-towel RTD mid-round, missing TKO causes).
- Chained shell commands: a failed `git add` (stale index.lock) let later `;` steps close issues with the wrong sha - check the lock
  first, and chain issue-closing with && after the commit.
- Windows text-input panel in front blocks computer-use clicks; ask the operator or wait, never fight for the screen.
Related: [[project-pc-crash-s218]], [[reference-arena-agent]], [[feedback-s217-visual-and-heat]].
