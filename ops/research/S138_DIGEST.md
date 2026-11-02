# S138 DIGEST - collect + merge wave, AAA verdict, hybrid fighters, the failing disk (Claude, 2026-10-01)

## 1. Operator rulings (verbatim where it matters)
- "none of what i saw so far is even close to AAA ... i still see a grey ring ... replace with real protraits of fighters
  and the tail of the tape needs to be changed accordingto our art direction always compare titles from our reseraches
  and try to surpass them visually" -> S138_AAA_VISUAL_GAP.md (audit + bar + route V1-V6).
- D29 "hybrid, start the metahuman pilot and assign codex to constantly work on animations (blender or cascadeur) and
  someone working on missing gated items": MetaHuman for close-up fighters, upgraded MPFB long tail, portraits rendered
  from the fighter's own model; Codex permanently on animation (AgentComms/codex_animation_queue.md).
- Inside uppercut video: "this video is terrible what happenned ?" + "why in the videos the second fighter is still ?" ->
  WITHDRAWN from the palette; RULE: a move is judged on a LIVE-ROOM video (receiver active) and certified only after the
  operator approves it (memory feedback_show_animation_as_video).
- "it's too early for steam yet". Next Fest Oct 2026 closed (reg Aug 31) -> Feb 2027 is the one Next Fest; Steamworks +
  $100 is the operator's call (S138_PROTO_BOXING_SURVEY.md).
- Bot art: 12 picks imported (assets/ui/bot_art); "glowing 3D body ... ok go for that" -> U209.
- Rooms: "who is working on improving the rooms constantly ?" + "make sure qwen has everything need to be an expert
  designer/artist" -> ROLE_QWEN_ROOM_DESIGNER.md, Qwen on a VISION model (was text-only qwen3-coder).
- Token Plan "you have 6 days to exhaust this" (47.5% of 45,000 left 23:08, resets 2026-10-08 19:00) -> 4 token-plan
  Qwen seats in parallel. kimi-k2.7-code is NOT on the plan (403).
- D: drive FAILING (WD15EARS, 758 read errors, 11 storahci resets in 2 weeks = the PC freezes): worktrees on E:
  (CLAUDE.md s4), D: read-only, backup E:/FightCamp_backup_D (3,199 files, 9 GB, 0 errors); operator buys a drive.
- "get rid of higgsfield": /generate skill on fal.ai built (needs FAL_KEY from the operator); cancel = his yes pending.
- Settings check: auto-PR / auto-fix / auto-archive all OFF = correct.

## 2. Merged (each as a diff, stills OPENED, tests on master)
C230 personality+heat (fixed: bias after the rest term, standoff lean, heat volume; every generated fighter now has a
personality - starters + offer opponents read "Disciplined" before; census ON 43.3% / OFF 46.7% KO+TKO, both in band);
Q223 honours (strip under the ladder fixed) + trophy/belt/medal art wired via UIKit.art_plate (navy-keyed cutouts);
G154 offer desk (button order, clipped matchup fixed); Q224 fatigue/body (stills rendered by Claude; Body Lab overflow
fixed); C231 merged then WITHDRAWN (see 1); U205 week in review; G155 camp consequences; C233 floor+lobby pass 1;
look pass 1 (AgX, bloom, SSAO, haze, shadowed ring key, skin SSS, MSAA - better, not AAA); start's live-run scan fixed
(os.walk over 24 HDD worktrees -> git, 10+ min -> 2.5 min); rivalries_test fixture (G153 gates injured fighters).

## 3. In flight at the end (ALL on E:, collect next session)
Codex C231B (wt E:/FightCamp/wt/C231B, inside uppercut redone, astra); Cursor U208 (tale-of-the-tape previews, then U209
Body Lab 3D, wt U208); Grok G156 (wire the rest, wt G156); Qwen Q225 (lobby+floor, qwen3.8-max), Q227 (office+locker,
qwen3.8-max), Q226 (fight inputs, deepseek-v4-pro), U207 (bot art, qwen3.7-plus). MetaHuman pilot MH1: a Claude
background agent in THIS session (wt E:/FightCamp/wt/MH1, branch claude/mh1-metahuman-pilot, UE project
E:/FightCamp/metahuman_pilot) - it may stop with the session: read its worktree + MH1_DIGEST.md if present and finish it.

## 4. Rules earned
- The C223 move gate holds the receiver still by design: its renders are benches, never operator review material.
- A SubViewport does not inherit project AA. All venue lights had shadows off; the live bout had no AA, no tonemap.
- FighterPortrait renders white mannequins (skin not applied in that path) - U208 fixes it.
- `git apply --3way` STAGES; another session's commit swept those staged files (S137's d9eca8f1). Use plain `git apply`.
- The browser pane auto-opens every .html written; SendUserFile display=render pops panes - operator: "open everything
  in background do not interupt on the other monitor" -> attach, no pane.
- Grok bot chats: collect_chat.py misses the newest replies (virtualised list) -> Tools/grokbots/dump_full.py (newest
  first); images live in %APPDATA%/Grok Bot/attachment-image-cache (213 copied to D:/FightCamp/bots_art).

## 5. Next (the decision)
Collect the 8 runs as they land (diffs, stills opened, live-room video for any move); re-task each seat at once (Token
Plan must be spent by 10-08); MetaHuman pilot verdict -> head library; V1 ring, V2 crowd (VAT), V5 tale of the tape from
the operator's U208 pick; then the exe only when the wiring audit is clear.
