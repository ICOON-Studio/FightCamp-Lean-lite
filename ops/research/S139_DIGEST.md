# S139 DIGEST - collect wave, the failing disk off our path, ring V1, impact VFX, the clinch designed (Claude, 2026-10-01/02)

## 1. Operator rulings (verbatim where it matters)
- "stop the windows popping up on my other monitor and put that in your memory" / "wtf are all these photos popping up
  all the time" -> agents opened their stills in the Photos app: `Tools/no_popups.ps1` guard (started by agent_window.ps1),
  CLAUDE.md s4 rule, every brief says "file tool only, never a viewer".
- "make sure thre is nothing on d that we use" / "move blender,clis to c and everything that is missing to e": the
  PAGEFILE (45 GB) was on the failing D: = the freezes (the operator moves it - system setting, steps given);
  Blender/Grok/Kimi -> C:\Tools, MPFB assets/uv/cache/downloads -> E:, scripts + user PATH repointed (588a8f5f);
  `start` no longer scans the 25 old D: worktrees. D: is NOT repairable (758 uncorrected read errors, 51,325 h).
- "use a new chat for kalli !!!!!" -> every bot task goes `grokbots.py send --to <bot> --new` (memory + README).
- "ok merge it" (C237 hit reactions) -> merged. "can you make visual effects with the connected throw when it lands ?"
  -> impact VFX (s5). "keep working on this and maybe put a threshold when the distance is too close to clinch ?" +
  "do a proper intergration of the clinch, who initates it, why , what are the penalties etc" -> S139_CLINCH_DESIGN.md,
  Q233 (engine) + C240 (room). "check for all branches for unmerged work and report" -> s4.
- "i see a lot of sliding in the video why the 3d fight is getting worse ?" -> measured (s6): NOT worse; old and large.
- Steam: he paid the Steam Direct fee (verified in Steamworks; bank + tax are his; no app ID yet). MetaHuman: he
  installed Core Data, then unticked editor symbols (C: 33 -> 86.8 GB free).

## 2. Merged (each as a diff, stills/video opened, tests on master)
U207 bot art (+ Claude fix: a contract finish-bonus tile claimed "Performance of the Night"); G156 the remaining
decisions/word modules (+ fight-week captions moved into THE TAPE); rooms pass 2 Q225 lobby+floor, Q227 office+locker,
Q228 FILM ROOM (new, WATCH FILM from camp), Q229 mat+staff+physio (+ fixed 6 parse errors where three `_pbr` helpers met
down one inheritance chain); C237 receiver reactions + moving guard (operator OK; its stale test fixed b12aa212);
V1 RING by Claude (procedural canvas shader, navy emblem + wordmark, round ropes, ties, printed skirt, c5b73359);
red irises fixed on every generated fighter (8274a057); impact VFX (c89b4694); K83 scorebug module written (not mounted).
Process slip, recorded: C237's staged files rode into the C240-queue commit (08b4444f) before its tests finished.

## 3. Collected, not merged yet (next session merges)
Q226 census (ON KO+TKO 49.2% / OFF 43.3% in 40-55; thrown 40.7 vs 40.8 = engine baseline below 45-56, not Q226's) - merge
it; Q232 rooms bright and alive (luminance up in all 8, 15/0) - merge; C232 walkout in the booked venue (31 checks, video
`E:/FightCamp/wt/C232/previews/c232/northlight.mp4`; flags folded-leg poses also without the walkout) - judge
the video, show the operator; MH1 MetaHuman Core Data pass (7756d7f6: preset boxer, synthesized skin, brush cut + brows,
61.7k tris 5.2 MB; operator sent portrait + jab) - awaiting his look verdict for the head library. C231B inside uppercut
shown, NOT certified (flat path), withheld.

## 4. Branch census (operator asked; 122 branches ahead of master)
79 merged as diffs (>=85% of their added code on master); of the other 43: 19 merged with changes, 5 superseded,
18 rejected/parked with recorded verdicts, 1 in flight (Q174 -> Q233), 1 UNMERGED VALUABLE = qwen/q175-clinch-land
(bell-break fix 69fb0764 + boxing_hold switch ca6aaf3a) - now inside TASK_Q233. Nothing unaccounted.

## 5. Impact VFX (operator ask) - c89b4694
Every landed punch queues an impact that fires at the frame the attacker's nearer glove is CLOSEST to the head/chest
(<= 0.32 m), never at the decision; a glove that never arrives fires nothing. Flash + shock ring + white core + spray,
aged by the FIGHT clock (2x/4x/pause and frame-by-frame recordings match play - real-time tweens were invisible in the
recorder). 20 s seed 92012: 8 fired, 2 dropped. Video sent (docs/previews/s139_vfx/impact_effects.mp4). Trace:
FIGHTCAMP_VFX_TRACE=1.

## 6. The sliding (operator: "why the 3d fight is getting worse ?") - MEASURED, not guessed
`tools/s139_slide_probe.gd` (planted-foot horizontal travel on the posed bones, 3 seeds x 30 s, as_game):
BEFORE C237 5773 cm/fighter-min, p95 2.70 m/s; AFTER 5351 cm, 2.64 m/s. Today's merges did not cause it; the slide is
old and large (the 4 cm plant band also counts low shuffle steps, so absolutes overstate - the p95 is the defect).
The industry fix the history never landed: FOOT LOCKING in the live room (lock a planted foot's world position, two-bone
leg IK to it, release on lift, stride-matched root) - U185-U188 tried variants and measured worse; next session briefs
it fresh with this probe as the gate (before/after on the same seeds, p95 planted speed down by >= half).

## 7. Rules earned
- A freeze on this PC = the pagefile on the failing D: + RAM exhaustion (MH1: the preset's default outfit built 4K/8K
  textures in the UE commandlet). Clear the outfit slot before spawning a MetaHuman; pagefile off D:.
- Three helpers named alike down one inheritance chain = parse errors only at the merge: run check_scripts on the
  WHOLE chain after merging agent branches that share a base class.
- A plain `git commit` takes everything staged - commit with explicit pathspecs (`git commit -- <files>`) while a merge
  is staged.
- A recorder that steps the room by hand outruns real-time tweens: drive effects from the fight delta.
- Agents "open every still" -> they launched viewers. Briefs now say: file-read tool only.

## 8. Next (the decision)
Collect as they land: U208c (Cursor, tale of the tape send-back 2), Q231 (big venues), Q233 (clinch engine, deepseek),
C240 (clinch room, Codex), G157b (crowd, Grok - resumed), Q230b (regional venue renders). Merge Q226 + Q232 now.
Then: brief FOOT LOCKING (s6) on the first free engine/animation seat; mount the K83 scorebug in FightWorldLiveScreen
(module ready, `_build_round_clock` / `_update_round_clock`); then the exe walk for the 10-06 demo.
