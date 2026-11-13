# S447 handover (written 2026-11-13 ~08:20 at the end of S446; S445's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S447`.

## USAGE RULES (kept)
`get_usage` first; hand over at 300k context; at most TWO helpers; tell him the cost before a batch.

## HIS WORDS IN S446 (verbatim)
- "replace cursor with grokbots,arena,goose" -> done: Grok Dev = screens + look fixes, Goose = long cloud jobs, Arena = pure
  modules; CLAUDE.md roles, seat_dispatch (cursor who=()), roadmap rows, memory feedback_cursor_replaced_s446.
- "check undisputed and blood&canvas how they do it do not waste time end effort if you can get it ready" -> answered from our
  own REA notes (ops/research/POWER1_AUDIT_S446.md): B&C freezes both 0.04 s; Undisputed no freeze, follow-through 0.08-0.31 s.
- "yes merge it" (Q-207) -> POWER1 steps 2-4 merged 74a910de, 12 fight tests green, pushed.
- "give me the links what you want to buy" -> Punch Perfect (Unity, EUR 36.76 + VAT) and animo-mocap Boxing Animation Pack
  (Fab, EUR 58.57); links in ops/research/MOCAP_PACKS_S439.md. Neither is in any library we own (checked). He buys end of Nov.

## DONE IN S446 (all pushed)
- POWER1 2-4 merged after an audit; leftovers queued: POWER1B, GLOVECLASH1, JOINFIX1 (Grok Dev), FEETDIPS1 (Goose), HOOKTAKES1
  (after the mocap packs). TASK_POWER1.md restored. Films docs/mockups/s446/power1_*.png (review board).
- ASKPROBE2 collected (tools/ask_probe2.gd, docs/ASKPROBE2_RESULT.md; PR 240 closed). x1: spread ok but flat (ask vs wait even
  40/36/49 of 60), teach words differ 20/60. x1.5: DOMINANT (step up wins growth 42/60), words 31/60.
- PAGES2 sent to Grok Dev 07:40 (`gbot send --to dev`; branch grok/pages2; it skips the still - render it yourself).
- BLOCKLOOK1 finding: ops/research/TASK_BLOCKLOOK1.md (block pose unchanged by POWER1; probe staging + mc_to_block).

## NEXT, IN ORDER
1. ASKPROBE2 at step_teach=1.25 (~16 min headless): `python ops/Tools/godot_slot.py run --who claude -- <godot.exe> --headless
   --audio-driver Dummy --path . --script res://tools/ask_probe2.gd -- n_night=50 step_teach=1.25`. Both bars hold -> write the
   value into ASKFIGHT_MAP v4 + the rule module, two FRESH critics, 7+ both, logic check, one drawing. Still dominant -> 1.15.
2. Collect PAGES2 from Grok Dev (`python ops/Tools/gbot.py thread --to dev`; PR on grok/pages2); render the Fighters still.
3. BLOCKLOOK1, then POWER1B / GLOVECLASH1 / JOINFIX1 briefs to Grok Dev; RESULTLOOK1.
4. His open calls: fight screen regroup + filling shout as default (stills docs/mockups/s445/hud/), voices, PA mix.

## TRAPS (S446)
- `-- nopunchrange` turns off POWER1 step 4 ONLY; a "before" film with it still carries steps 2-3 - say so on the sheet.
- roadmap.json / live_runs.json are indent=1: rewrite with json.dumps(indent=1) or the diff is the whole file.
- tools/block_meet_probe.gd stages its own pair (GAP 0.80-1.10 m): its stills are not the played fight.
- `agent_comms.py ask --attach` needs an absolute path.
