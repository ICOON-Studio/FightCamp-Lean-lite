# S226 DIGEST (2026-10-15) - rooms start, globe to a shippable look, the wrist bend traced to the source, the guard re-baked

Operator rulings this session (verbatim):
- Q-S225-1 globe "use a better outliner"; Q-S225-2 "Yes, close the mirror part"; Q-S225-3 "the outliner and pin still looks very amateur ai
  made . also what about colours ?"; Q-S225-6 "build it with the appropriate menus and show it back to ludo"; chat: the card "this to blunt
  on the right", the pointer "needs some better visual special effects be a bit bigger add some blinking changing size and glow, it looks
  very cheap and ai as it is now".
- "should assign codex to fix all remaining rooms ? it did good job with the changing room" -> yes; Q-S225-4 "Yes, build all 4 rooms (26
  models, about 104 Ludo credits). Start with reception."; "should codex also refine the gym floor since it is making all rooms ?" -> yes;
  Q-S225-7 "Yes, spend about 24 Ludo credits on the 6 gym floor props."
- "how can you speed up production ?" -> CLAUDE.md s8 PRODUCTION SPEED; Q-S225-5 "I'll keep fewer browsers open" -> 3 PC agents on
  GREEN/AMBER (CLAUDE.md s8).
- "stills and videos on board are a mesh can you remove and start over from now" -> 30 posts to review/_removed (restorable), one post per
  thing, --supersedes for new versions (memory feedback_review_board_clean). "same for animations remove all animations with old models and
  i want only with MH" -> the 47 S130-S135 generator-body videos moved to anim/_old_models_s226, no generator fallback (page is empty until
  MH renders land). "grok is available on cloud use it" -> CORNERCALL1 on cloud Grok Dev #198. "are you idle ?" - yes, I had ended a
  turn with free seats; corrected.

## Merged to master (by diff; parse + the touched tests)
| Commit | What | Gate |
|---|---|---|
| 20a21082 | ANIMFIX2 r2 (Codex): pose layer authored in the generator rest frame, transported through raw rests; catch glove now at the face | anatomical_pose_layer 1/1; sole drift accepted (arm-only, 4/16 feet <1% worse, total outside 28,623 -> 28,582) |
| 86d76df8 | FLOORHUD1 r3 (Cursor #188) + Claude: hand cards were laid out off screen (root moved to y 960), the news bar clipped its own text | floor_hud2_route 20/20; stills on the game floor show cards + scrolling news |
| 63997f79 | GLOBE1 outliner (shader edges from the ID map) | globe 2/2 |
| 9b49e176 | nightly reds: _reveal_note_first_fight reads by type (ambitions, fight_playback script errors); locker Ludo pack manifest entry | 3/3 |
| (runner) | run_tests retries 0xC0000142 launch failures 3x; nightly latest.txt says ABORTED with no SUITE line | - |
| GLOBE2 + 2B | Cursor #196/#197 + Claude render fixes (sRGB colours, matte ocean, land-side coasts, transparent viewport, world-space medallion, tag above, card padding/flag, glow 1.15) | globe+creation 6/6; Ludo 4.8 -> **8.2/10, "shippable"** |
| (pointer) | pointer FX: 1.5x, breathing scale, gold halo, radar rings, bezel glint, light shadow; tools/globe_pin_clip.gd (movie writer) | globe 3/3; clip on the board |
| 9764600f | ROOMS3A reception (Codex): 6 Ludo props + locker bench, verdict layout, lights, existing-route clicks, room HUD backing plate; manifest entry | reception/club/room 13/13; 31.5/40 credits |
| (anim page) | animations page = MetaHuman only | 0 old previews |

## Findings
- ANIMFIX2B: the guard wrist bend is in the SOURCE (active_guard.glb 19 deg); ANIMFIX3: the native MH guard is bent too (19/27) -> OFFBAKE1.
- OFFBAKE1 (codex/offbake1, NOT merged): Cascadeur bake straightens every wrist (0.19/0.32 deg). Claude opened all 12 A/B stills: guard,
  jab, cross BETTER natively; hook (head turns away) and uppercut (reads as a crouch) WORSE. Ruling -> TASK_OFFBAKE1B: native for
  guard/jab/cross only, re-author hook + uppercut in Cascadeur from the new guard (before 10-27).
- fight_contact_stop red since 20a21082: ANIMFIX2 shifted the timeline and exposed a latent low kick landing 1.14 m short -> Goose #194.
- Nightly 10-15 aborted at 353/789 (DLL-init launch failures under load), not 450 reds.
- Heat: I started tests once on RED (86 C) - a rule break; nothing launched afterwards until AMBER.

## Ludo rounds (all saved verbatim)
r65 four rooms (30.5k+30.9k+14.0k) + verdict (counter blocking the walkway, office doors mirrored, physio overlaps at 1.2x); r66 globe
look (33,242 chars = new high, + reference picture); r66B review 4.8/10; r66C review 8.2/10 shippable (+ a medallion picture from a
suggestion chip clicked by accident - upload by ref now, memory reference_ludo_ai); r67 market card (31.6k).

## In flight at handover
- PC: OFFBAKE1 (codex, wt ANIMFIX2, finishing - collect = ruling above, then OFFBAKE1B); PROFILE2F (codex, wt PROFILE2E, face camera).
- Cloud: GLOBE2C market card (Cursor #199); CORNERREPORT1 (Arena 01a1406a); CORNERCALL1 (Grok Dev #198); KICKREACH1 (Goose #194).
- Queued for the next free PC seat: OFFBAKE1B (Cascadeur deadline) -> GYMLOOK3B (props approved) -> ROOMS3B store (then office, physio).
- Board: Q-S225-8 globe ship call (Ludo 8.2/10); reception + globe pointer + OFFBAKE1 A/B on /review.
