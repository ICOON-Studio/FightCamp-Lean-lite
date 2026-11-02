# S140 DIGEST - hit pop-up, MetaHuman pilot merged, the cheaper mode (Claude, 2026-10-02)

## 1. Operator, verbatim
- "metahuman model is better" -> MH1 pilot passes its D29 look gate; merged (78f5a32e).
- "the impact need to be cleared ju add a pop up showing the hit and the damage" -> hit pop-up (5129d0a4).
- "you have 12% usage already within 10 hours, is that normal ?" ... "switch to the cheaper mode first and do 1-4
  actions" -> s4.

## 2. Hit pop-up (5129d0a4)
FightVfx.impact_flash (light, shock ring, white core, spray) removed. FightVfx.hit_popup: Label3D over the struck head,
punch name + region points cost (ImpactModel wear summed; regions start at 100), gold clean / grey glancing, drawn
through bodies, pops 1.3x -> 1x, rises 0.30 m, fades its last 0.4 s, 1.2 s life on the FIGHT clock. Still fired at the
glove's contact frame (S139 timing). Defect fixed in passing: the pending entry read beat["damage"], which no beat
carries (every punch was power 1.0) - now beat["wear"]. fight_vfx_test 36/0; run_tests --only
fight_vfx,fight_world_live,fight_world_mount 3/0; live record seed 92012 20 s as_game: 8 fired, 2 dropped, frames
opened; video docs/previews/s140_popup/hit_popup.mp4 sent. Seen: "Jab to the Body" can land head_neck (body_damage =
85/15 torso/head by design, FightMoves._regions_for) - the pop-up names the true region. Operator taste check owed.

## 3. MH1 merged (78f5a32e)
Applied as a diff from claude/mh1-metahuman-pilot (813e254c + 7756d7f6); MH1_DIGEST.md already identical on master.
TASK_MH1.md written at merge (the pilot ran on D29 without one); check_workflow branch MH1 = 0 defects; parse 2/0.
Next = MH2: the demo boxers as MetaHumans (preset per fighter, Outfits slot cleared first, perf with hair cards on an
idle PC - D29's reopen bar is 60 fps with two MetaHumans in a dressed venue).

## 4. Usage budget - the cheaper mode (operator chose actions 1-4)
Pro plan; weekly 12% used ~13 h into the week (resets 2026-10-08 14:00) = out by ~day 5 at that pace.
1. ~/.claude/settings.json model=sonnet, effortLevel=medium (this session cannot re-price itself).
2. Connectors Higgsfield (98 tools), Higgsfield Blender (170), Claude Docs (8) OFF, default for new sessions too.
3. CLAUDE.md s3: one stage per session, hand over at ~150k context or stage end; `start` once.
4. CLAUDE.md s8: delegate implementation to the shell agents by default; Claude briefs, reviews, merges, judges.
Not chosen: relaxing the never-idle Stop hook.

## 5. Not merged (gate defects, recorded in roadmap now)
Q226: three-dot diff vs master = 173 files incl. Tools/no_popups.ps1 + Tools/grokbots/open_nth.py (100 defects) - take
only its owned files' diff. Q232: TASK file's Owned list omits the room scripts a "rooms bright" task must change (8
defects) - fix the task file, then apply.

## 6. Route decisions
C237, G156, Q228 written DONE in route_decisions.json (merged S139) - the DROPPED-ROUTE defect is clear.

## Next
Collect the five runs in flight (C240, G157, Q230, Q231, Q233); merge Q226 (owned files only) + Q232; mount the K83
scorebug; brief FOOTLOCK and MH2 to agent seats.
