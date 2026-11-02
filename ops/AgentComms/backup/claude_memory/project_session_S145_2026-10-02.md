---
name: project-session-s145-2026-10-02
description: "S145 - icons blank in exe fixed (raw svg not packed), first-hour cards, C243 a fight for every fighter (signed fighters had no country -> no amateur body), Grok balance exhausted"
metadata:
  node_type: memory
  type: project
  originSessionId: fc7f9661-9559-41a3-8e2a-fed036a0c7ed
  modified: 2026-10-02T15:45:18.454Z
---

S145 (2026-10-02 evening, Opus). Digest: research/S145_DIGEST.md.

- P10 blank icons in the .exe: IconKit read raw .svg via FileAccess; exports pack only the imported copy. 348 svgs now
  `importer="keep"`; build_playable.py parses the pck FILE TABLE and fails the build if one is missing. Lesson: any raw
  read (FileAccess / Image.load_from_file / RawAsset) of an importable file works in the editor and breaks ONLY in the exe -
  verify UI in the exported build ([[feedback_playtest_like_a_pro]]).
- C243 root cause was NOT the brief's code-read: a SIGNED fighter has no `country` key and get_gym() has none either
  (career.world.country) -> no amateur body for any signed fighter. Plus empty novice buckets for men too, and a pro fame
  gate leaking into amateur bouts. Fixed with club-show novices (career.club_show_novices, game ON) - see
  [[feedback_bucket_defect_by_clip]] (measure first, the code-read named the wrong cause again).
- Grok Build API 402 "usage balance exhausted" at 18:28 -> Grok OUT; Cursor/Qwen already out; only Codex left. Top-up = operator.
- get_usage showed plan "Max" (CLAUDE.md says Pro) - context hit 310k this session; hand over earlier next time.
