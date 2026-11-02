---
name: project-session-s217
description: S217 (2026-10-13) - merged MIXAMO1C/RECOVERY1A/NIGHTLY5B/MH cast fix; heat governor + rule guard; cloud seats (Goose on Qwen key, Grok xAI key, Arena x2); Ludo r50-52; Mixamo batch 2; handover at 601k
metadata:
  type: project
---
Digest: research/S217_DIGEST.md (full HANDOFF list). Handover was LATE (601k, mark is 330k) - check get_usage every ~2 h.
- Uncommitted at handover: RECOVERY1B+1D+for_athlete swap, Mixamo batch 2 (6 FBX + MixamoMotion categories) - their tests run in the
  detached queue E:/FightCamp/tmp/s217_queue.sh -> s217_queue.txt (cast stills first). Commit only on PASS.
- Operator rulings: story skippable + story = tutorial (Ludo r52 agrees; board Q-S212-12); "use goose and qwen too on cloud";
  Arena from Claude's own pane from now on ("can you use it on your own console"); usage band removed.
- Seats: Goose = goose.yml on QWEN_API_KEY (openai provider, token-plan host); Grok cloud = XAI_API_KEY + opencode, model id still
  unknown (run 38374613766 prints `opencode models xai`); Grok Dev bot + skill fightcamp-coding-seat exist, need GH_TOKEN in the box.
- Heat: Tools/heat_governor.ps1 must be restarted after a reboot (not a scheduled task yet).
Related: [[feedback-s217-visual-and-heat]], [[reference-gbot-cli]], [[reference-usage-meter-mod]].
