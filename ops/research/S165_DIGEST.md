# S165 digest - EXE-S3: the .exe with STORY3 + NAME1, a fought bout walked in it (Claude, 2026-10-05)

## 1. What now works (evidence opened by me)
- **Agent sweep first** (CLAUDE.md s3): Arena NAME1 (chat 01a10c45) and Arena NIGHTLY1C2 (chat 01a10c46) launched in the first 20 minutes
  from `TASK_NAME1.md` / `TASK_NIGHTLY1C2.md`. NAME1 came back as PR #49 within the hour; reviewed, mutant-proved, diff applied -> `9c9f4b36`.
- **NAME1 merged**: the gym step asks YOUR NAME (placeholder Coach, max 24) beside GYM NAME and STORY; the cards say `{you}` ("Coach" when
  blank). `new_career_player_name_test` 37 headless / 43 `-- as_game`, `story_campaign_test` 110; both red with the `{you}` replace removed.
  Still: `docs/previews/s165_story_beside/08_gym_step_beside.png`.
- **The .exe rebuilt twice** (`python Tools/build_playable.py`, pck 542 MB; final 16:51 with STORY3 + NAME1 + the HOME fixes).
- **A FOUGHT BOUT walked in the exe** by clicks only: `research/s165_fight_walk.plan` (empty gym -> scouting -> sign Torres -> OFFERS -> EVEN ->
  ENTER THE CARD -> SET CAMP -> camp weeks through two week reviews -> ENTER FIGHT WEEK -> weigh-in -> fight night -> BEGIN FIGHT -> SIM TO
  RESULT -> RESULT (Torres UD 30-27 x3) -> BACK HOME -> next week). **59 steps, 0 failures, 0 SCRIPT ERROR**, on both exe builds
  (`docs/previews/s165_exe_walk`, `s165_exe_walk_final`). Walker: `until TARGET|Continue,Next week|80` (STEP may list several labels).
- **STORY3 seen in the real game** (`s165_story_beside_walk.plan`, Beside mode, dev tree): Schedule > MY GYM NEXT UP "Dessa's call is waiting"
  -> OPEN THE INBOX -> THE INBOX with 4 waiting cards addressed to "Coach" -> answer -> 3 waiting (`s165_story_beside/20,22,24`).
  Note: with an EMPTY gym the NEXT UP is "Sign your first fighter" (precedence by design); the story promise shows once a fighter is signed.
- **Three defects fixed on sight** (CLAUDE.md s2), each on the game camera and with a test that went red on the shipped tree:
  1. HOME: the NEXT FIGHT card took Torres's generated face first, so his roster tile stepped to ANOTHER man's face (`DayFeedPanel._portrait_path`
     de-dup keyed by id now). 2. The Front desk pin sat under the first fighter card (moved to (330, 880), plate left). `day_feed_screen_test` +3.
  3. THE INBOX lit "Roster & floor" with crumb "Gym" (route nav gym -> calendar). `story_inbox_panel_test` 10/0, `scene_router_test` 254/0.
- Week review: the first dead-end shot showed an EMPTY grey week review - it was the reveal animation (0.8 s settle); at 2.5 s it is whole.

## 2. NOT done (said plainly)
- **POPUPS**: the operator wrote twice during my runs: "please no popups on my other monitor", then "i keep seeing popups stop it". Every
  windowed run went through `Tools/godot_hidden.ps1` (hidden desktop since S161) - exe walks with `FightCamp_console.exe`, then `FightCamp.exe`
  + `--log-file`, dev-tree walks with the console Godot; the builds ran the non-console Godot headless. Two `Photos.exe` were alive at 18:00.
  I could not tell which window he saw. NOTHING windowed runs next session until the launcher is proven silent (ask him the window title).
- NIGHTLY1C2 still running on Arena (it was compiling Godot from source in its sandbox at 17:40). Collect its PR; run the six neighbours on
  master AND the branch before merging (S163 lesson).
- STORY4 (the Wall + HOME pin), STORY5, STORY6 writers (Dola sent; John/Maria/Kalli owed), KM3-RIGS, PR #43: queued.
- Seen, not fixed: the scorebug says Torres 7-4-1 while HOME and the fight card say 7-4 (the draw is dropped on the short record); Hassan reads
  0-0 on the NEXT FIGHT card and 1-0-0 on the scorebug. Both are one-line reads; a defect for the next HOME/scorebug pass.

## 3. Traps recorded
- A dead-end shot can show a half-built screen: the week review reveals over ~1-2 s; shoot after `wait 2.5`.
- The scouting row hitbox's label is the avatar initials (`@BT`), not the name; `@PROSPECT` is the sort button.
- An Arena sandbox may compile Godot from source (slow) - a task that only needs the parse gate should say "CI runs the tests".

## 4. Operator playtest after the ship (18:xx)
- He ran the OLD Unreal prototype at Builds/Windows/FightCamp.exe first (Aug 29) - the Godot game is Builds/FightCamp_Godot/FightCamp.exe; remove the old folder on his word.
- HOME, empty gym: 'nowhere says Scouting in the screen' - the FIRST JOB says Open Scouting but the rail hides the Fighters pages until Fighters is open. Hotfix: the Fighters area stays open on HOME while the gym is empty (ShellChrome._build_rail; day_feed_screen_test). The structural pass he asked for ('a AAA class lead game designer... the right menu structure') is NAV1, first next session.

## 5. NAV1 (operator 18:40-18:50)
- 'remove the menus and use the 3d engine maybe for everything? put a timeline bar on top to progress continuously' -> NAV1_THE_GYM_IS_THE_MENU.md: design on paper (the S159 design of record already says the gym is the home screen, not a menu), 4 slices behind a switch, his go/rail asked.
- Briefs out via gbot (new chats): J62 reference screen logic, K86 gap audit + candidate card, M42 mocks; all carry Option B.
- Tooltips on the candidate tiles shipped (5e4ffc44); the pack rebuilt - he must restart the exe to get it.
