# TASK C134 — CODEX — THE BJJ / GRAPPLING 3D PRESENTATION, FINISHED TO A WATCHABLE BJJ AND MMA MATCH

Model: **GPT-6 Astra**, reasoning **medium**, Fast OFF (operator, 2026-09-20 — this overrides the
standing `gpt-5.6-luna` pin for this task only). Owner: codex. Stage: S4e (ENGINE FIRST) / presentation.
**Workspace: `C:/Users/user/AppData/Local/Temp/FightCamp-C134`, branch `codex/c134-bjj-presentation`,
cut clean from `origin/master` at `aa52b7ee`. Push the BRANCH. Never the main checkout, never master.**

**Subagents: ALLOWED, but for READ-ONLY asset inspection only** (enumerating clips, reading skeletons,
measuring FBX). **Never for implementation, bindings or tests** — the edits must stay coherent in one
head, and fan-out is how a bounded stage turns into a broad repository scan. If you do not need one,
do not spawn one.

---

## 0. THE SHAPE OF THIS TASK

Three bounded stages. **Report at the end of each, in a few lines, before starting the next.**

1. **ASSET ASSESSMENT** — confirm what is on disk against §4, and confirm you can boot Godot (§8).
2. **ONE COMPLETE GRAPPLING SEQUENCE** — standing → takedown → a held ground position → one
   transition → a submission with tap and release, playing without visual defects.
3. **MATCH COVERAGE AND INTEGRATION** — the rest of the required coverage, both match routes, the
   capture, and the honest defect report.

**Do not scan the repository broadly.** Every file you need is named in this task. Read those, and
`rg -n` for a specific symbol when you need one more. `FightRealtime.gd` is 4,059 lines and
`FightClipBinding.gd` is over 1,200 — **never open either whole**; read the windows named below.

**If you need higher reasoning, say which specific blocker needs it and stop** — do not grind.

---

## 1. WHAT THIS IS FOR

The operator's verdict on the 3D fight, standing, is that it is **painful to watch**. The ground game
is worse: the simulation already plays a full BJJ or MMA ground exchange — seats, sweeps, passes,
submissions — and **the room shows almost none of it**. This task ends with a BJJ match and an MMA
match a person can watch and believe.

**Passing the test suite does not finish this task.** The suite is green today on a ground game that
is largely invisible. The deliverable is what the operator sees moving.

---

## 2. CURRENT IMPLEMENTATION — VERIFIED 2026-09-20, NOT GUESSED

### The authoritative engine

**`Godot/scripts/FightRealtime.gd` (4,059 lines) is the live engine.** `FightSimulation.gd` is a
SECOND, atomic engine with its own constants and its own knockdown/grapple numbers — **it is not the
one the 3D room runs.** Never blend a claim from the two; say which one a measurement came from.

Grapple seams in `FightRealtime.gd`, read these windows and not the file:

| line | what |
|---|---|
| `:3553` | `_run_grapple` — the decision cadence, four draws, the `standing` / `clinch` / `ground` branch |
| `:3536` | `_log_grapple` — **the single door every grapple event goes through** |
| `:1598` | `_go_down` — the one place a man goes down |
| `:681` | `advance_tick`, and `Budget.DECISION` / `Budget.IMPACT` in the tick loop at `:1350` |

### The grapple vocabulary you must cover

`Godot/scripts/GrappleSeat.gd` (89 lines — **read it whole**) is the canonical state:

```
STANCES := ["standing", "clinch", "ground"]
SEATS   := ["none", "over_under", "guard", "half", "side", "mount", "back"]
```
plus `top` (which man is on top, `-1` for neither). `is_legal(from_stance, from_seat, to_stance,
to_seat)` defines every transition that can occur — **that function is your coverage specification.**

`_log_grapple` emits these `kind` values, and they are the beats the room can present:
`control`, `seat`, `stall`, `submission_attempt`, `takedown_attempt`, `throw_attempt`.

### Simulation → animation

The chain, in order:

1. `Godot/scripts/FightBeatAdapter.gd` — turns engine events into beats (`kind` / `via` words).
2. `Godot/scripts/FightLiveSchedule.gd` — when a beat is allowed to be shown.
3. **`Godot/scripts/FightClipBinding.gd`** — beat → clip. **This is the centre of your task.**
   - `BINDINGS` — single-actor clips, one `path` each. **There is no way to hand that path a pair.**
   - `PAIRED_BINDINGS` at **`:882`** — the two-body table. Read `:850-960` for the design ruling.
   - `PAIRED_DIR = "res://assets/anim/audition/ramsterz/"`,
     `PAIRED_REFERENCE = "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx"`.
   - Consumers at `:1054` and `:1176`.
4. `Godot/scripts/FightStagePlayer.gd` (~1,390 lines, never whole) — plays clips on a rig.
5. `Godot/scripts/FightWorldLiveScreen.gd` — the room. `_ready` at `:248`, options parsed from `:373`
   (`seed`, `discipline`, `rounds`), arena resolved at `:446` via `_spec_for`.
6. `Godot/scripts/FightStageDirector.gd` — presentation vocabulary (`lead` / `rear` hand names).

### What WORKS today

- The engine plays a full ground game: seats, control, sweeps, submissions, taps, stand-ups.
- **Five paired roles are bound and do play as two synchronised bodies** (`PAIRED_BINDINGS`, `:882`):

| role | clip pair | length |
|---|---|---|
| `grapple_sweep` | `Paired_FullMount_Reversal` | 1.833 s |
| `grapple_takedown` | `Paired_FullMount_Takedown_DoubleLeg_Start` | 1.667 s |
| `grapple_throw` | `Paired_FullMount_Takedown_BodyLock_Start` | 2.333 s |
| `grapple_submission_attempt` | `Paired_FullMount_H2H_ArmBar` | 4.467 s |
| `grapple_submission_finish` | `Paired_FullMount_H2H_Strangle` | 6.000 s |

- The authored jab pair proves the paired path end to end
  (`Godot/assets/anim/pairs/BOX_JAB_HEAD_LAND_*.pair.json`).

### What is UNFINISHED — the honest list, from the code's own comment at `FightClipBinding.gd:855`

**Absent, with no film that depicts them:** `grapple_stall`, `grapple_mount`, `grapple_pass`,
`grapple_back`, `grapple_position_change`, `grapple_seat`, `grapple_clinch_engage`,
`grapple_takedown_attempt`, `grapple_throw_attempt`.

So: **the engine can sit in `guard`, `half`, `side`, `back` and `over_under`, and there is no
animation for any of them.** A held position is the single largest hole — a BJJ match is mostly held
positions, and the room currently has nothing to show for them.

**A DESIGN RULING ALREADY MADE, AND IT BINDS YOU** (`FightClipBinding.gd:860`):
> *"A wrong position is worse than no clip, because no clip is visible as absence and a wrong one is
> not."*

`BodyLock_Loop` was deliberately NOT bound to `grapple_stall` for exactly this reason — a stall can
be scored STANDING in a clinch, and playing a full mount there puts two men on the canvas who are on
their feet. **Do not "fill" a role with a clip that depicts a different position.** Leaving a beat
unshown and saying so is the correct outcome; faking it is not.

### Two more known defects, both load-bearing for this task

1. **A BJJ MATCH CANNOT STAGE IN THE 3D ROOM TODAY.** The `bjj` ruleset names
   `arena_profile: "grappling_mat"`, and **`grappling_mat` does not exist in
   `Godot/assets/data/arena_specs.json`**. `FightWorldLiveScreen` then says
   *"%s resolves no arena spec"* (`:448`) and stops. **Fixing this is in scope and is stage 3's first
   job.** A square mat with a safety area is a floor plane and bounds — do not model an arena.
2. `H2H_Punches` and `H2H_HeadSmash` (ground-and-pound films, owned and legal) are **not bindable as
   grapple roles at all.** Ground strikes do not come through `_log_grapple`; they arrive through the
   IMPACT subsystem as ordinary action beats with their own region, and `BINDINGS` has one `path` and
   cannot mount a pair. Binding them is a real stage — take it only if stages 1–2 land early.

### Relevant tests

`Godot/tests/`: `fight_beat_grapple_test.gd`, `grapple_adapter_test.gd`,
`grapple_adapter_contract_test.gd`, `fight_grapple_seam_test.gd`, `fight_world_pair_test.gd`,
`fight_pair_schedule_test.gd`, `fight_stage_realism_test.gd`.

**`fight_pair_live_test.gd` and `fight_stage_presenter_contract_test.gd` ARE RED ON PURPOSE** —
parked by the operator's 2026-09-15 ruling. Do not "fix" them and do not count them as your failures.

---

## 3. OWNERSHIP — WHAT YOU MAY EDIT

**Yours to edit:**
- `Godot/scripts/FightClipBinding.gd` — bindings, paired table, offsets, contact markers.
- `Godot/scripts/FightStagePlayer.gd` — paired positioning, transitions, blending.
- `Godot/scripts/FightWorldLiveScreen.gd` — match integration and arena resolution.
- `Godot/scripts/FightStageDirector.gd`, `Godot/scripts/FightBeatAdapter.gd`,
  `Godot/scripts/FightLiveSchedule.gd` — only where a beat must reach the room.
- `Godot/assets/data/arena_specs.json` — to add `grappling_mat`.
- `Godot/assets/anim/pairs/*.pair.json` — paired offsets and contact markers.
- New files under `Godot/assets/anim/`, `Godot/tools/`, `Godot/tests/`, `research/`.

**NOT yours, do not edit:**
- `Godot/scripts/FightRealtime.gd`, `GrappleResolve.gd`, `GrappleSeat.gd`, `BalanceState.gd` — the
  ENGINE. This task is presentation. If the engine is genuinely wrong, **report it, do not fix it.**
- `Godot/scripts/GameState.gd` (~13k lines) — never open it whole, never edit it.
- `HANDOFF.md`, `AgentComms/roadmap.json`, `CURRENT_STATUS.md` — Claude's.

**Held by another agent right now — DO NOT TOUCH, you will collide:**
- Branch `claude/s4a-combos` (uncollected, 7 commits) has live edits to **`FightLiveSchedule.gd`,
  `FightWorldLiveScreen.gd`, `FightClipBinding`-adjacent code and
  `Tools/blender_moves/author_pair.py`**. Keep your changes to those files minimal and well-separated
  so the merge is survivable, and **say in your digest exactly which of them you touched.**
- `Godot/tests/fight_combo_spacing_test.gd` belongs to that branch. Leave it alone.

---

## 4. EXISTING ASSETS — EXACT PATHS

### Fighters (rigged, 12)

`Godot/assets/models/fighters/f01..f12_*_rigged.glb`. For grappling use
**`f05_m_mma_light_rigged.glb` and `f06_m_mma_lhw_rigged.glb`** (both MMA, different frames).
**NEVER TEST IDENTICAL FIGHTERS** — operator rule, no exceptions. Two men from the same numbers are
not a control group, they are an unreal population. Differentiate by stats, frame and plan, and name
your population in your own output.

Loaded at runtime through `GLTFDocument` (R111). R95's verdict: **bodies shippable, faces not.**

### Skeleton / retargeting

- Paired reference rig: `Godot/assets/anim/audition/ramsterz_h2h/T_pose.fbx` (`PAIRED_REFERENCE`).
- Baked boot idles: `Godot/assets/anim/boot/idle_f01.res`, `idle_f02.res`, `idle_f05.res`.
- **Headless traps that will cost you a day if you do not know them:** `get_bone_global_pose()`
  returns the REST pose in headless; an FBX clip's hierarchy is NOT the rig's rest pose;
  `Vector3.FORWARD` is `-Z`; and `SkeletonModifier3D` / `TwoBoneIK3D` never run in
  `_initialize`-stepped tests.

### Grappling clips — all of them, `Godot/assets/anim/audition/ramsterz/`

16 `Paired_FullMount_*` pairs, each `_Att.fbx` + `_Vic.fbx`.

**Unarmed and usable (13):** `Reversal`, `Takedown_DoubleLeg_Start`, `Takedown_BodyLock_Start`,
`Takedown_BodyLock_Loop`, `Takedown_BodyLock_End`, `H2H_ArmBar`, `H2H_Strangle`, `H2H_Punches`,
`H2H_HeadSmash`, `AttackBlock`, `PushOff`, `VictimAttack`, and the `Vic` halves as their own films.

**Weapon clips — NEVER use in a sport sim (4):** `1HM_AxeToFace`, `1HM_BluntSmack`, `1HM_KnifeStab`,
`1HM_SlashNeck`.

**Five are bound (§2). Seven unarmed pairs are owned, legal, converted and UNBOUND** — that is your
cheapest material and the first place to look before creating anything.

Also present: `ramsterz_h2h/` (19 clips, standing H2H), `magicpot_fm1/` (43), `motifect/` (80, kicks
only, and its 17 weapon clips are barred).

### Paired offsets / contact markers

`Godot/assets/anim/pairs/BOX_JAB_HEAD_LAND_F01_F09.pair.json` and `..._F09_F01.pair.json` — the
authored jab pair, and **the worked example of the pair format**: `min_gap_m` / `max_gap_m` gate a
pair, and `authored_bearing_deg` plus a tolerance gates facing. Read one whole before authoring.
Authoring tooling: `Tools/blender_moves/author_pair.py` (**owned by `claude/s4a-combos` — read, do
not edit**).

### Original editable sources

`.fbx` as bought is what exists; there are no `.blend` sources for the RamsterZ packs. Blender 5.2.1
is installed and is the tool if you author. `research/SANDBOX_MODULE_TESTING.md` covers
throwaway-project testing.

### Licences — and whether derivatives are allowed

`Godot/assets/asset_manifest.json` is authoritative. Status vocabulary: `approved` = may be
referenced by shipped code; `candidate` = labs only; `placeholder` = blockout; `rejected` = do not use.

| pack | status | licence | derivatives? |
|---|---|---|---|
| `ramsterz_full_mount_attacks` | **approved** | Standard Unity Asset Store EULA | **Yes** — use and modify inside the game. **Never redistribute the raw clips as assets.** |
| `ramsterz_hand_to_hand_set` | **approved** | Same EULA (the Unity copy has no AI clause) | Yes, same terms |
| `motifect_martial_arts` | candidate | Free pack README: commercial use OK, **no redistribution of raw animation data** | Labs only — not shippable until approved |
| `magicpot_fighting_motions_vol1` | candidate | Unity EULA | Labs only |
| `tripo_fighters` (f01–f12) | approved | **NOT RECORDED** | The fighters you must use. Unresolved licence is the operator's to close — **not a blocker for this task**, but do not make it worse |

**Do not train anything on these assets** — the Unity EULA forbids AI/ML training on store assets.

---

## 5. MISSING ASSETS, AND WHAT YOU MAY DO ABOUT IT

Missing, in rough order of how much a BJJ match needs them:

- **Held positions:** `guard`, `half`, `side`, `back`, `over_under`, and `mount` as a HOLD (only
  mount-derived actions exist). A BJJ match is mostly these.
- **Transitions / passes:** guard → half → side → mount → back, and every reverse.
- **Escapes:** shrimp / hip-escape, bridge-and-roll, back escape.
- **Takedowns beyond two:** only a double-leg entry and a body-lock exist.
- **Tap and release:** the tap gesture and the separation after it. **The acceptance criteria require
  a visible tap and release, so if nothing depicts it, this is the one you most likely must author.**
- **Submissions beyond armbar and strangle.**

**YOU ARE AUTHORISED to create original animation assets locally** — Blender 5.2.1, or posing and
keying from the existing rigs, or splicing owned clips within the EULA. Original work you author is
the project's own and carries no third-party licence. Put new clips under
`Godot/assets/anim/authored/` with a manifest entry.

**A held position is cheap to author and a throw is not.** A two-body HOLD is a static pose per body
plus small idle motion; that is the highest value per hour available here and it is where the code's
own gap list is emptiest. Prefer it over anything dynamic.

**PAID ASSETS OR PAID GENERATION NEED THE OPERATOR'S APPROVAL, ALWAYS.** If you conclude something
must be bought, stop and write a concrete proposal: the exact SKU with its id and price, what it
covers that authoring cannot, and what it replaces. The natural candidates are RamsterZ's own
(`227376 Wrestler Finishers Vol 1` EUR 36.79, `248067 Vol 2` EUR 41.39, `227027 Non-Lethal Counters`
EUR 22.99) because their `_Att`/`_Vic` convention already matches `PAIRED_BINDINGS`. **Propose; never
purchase, and never assume approval.**

---

## 6. RULES AND COVERAGE

### The ruleset exists and is real

`Godot/assets/data/combat_rulesets.json`, id **`bjj`**: *Brazilian Jiu-Jitsu*, arena_profile
`grappling_mat` ("Square Grappling Mat + Safety Area"), **1 round of 600 s**, no rest, judging
*"Submission or positional points and advantages"*, `scoring_profile.style = "points"` weighted
entirely on **positions (1.0) and submissions**, with damage / volume / knockdowns / control at 0.0.
That is an IBJJF adult black-belt shape and it is the ruleset to use.

### GI OR NO-GI — DECIDED: **NO-GI**, and here is why

The ruleset carries **no gi/uniform field at all**, and **there is no gi, kimono or belt asset
anywhere in `Godot/assets/models/`**. A gi is a garment to model, rig and simulate cloth on — a
project of its own, and nothing in scope here depends on it. **First playable scope is NO-GI**, which
also lets the same clips serve the MMA match. Grips are then body and limb grips, never cloth.

If the operator later wants gi, it is a new stage, not a variation of this one.

### Coverage required — visible, in the room

From `GrappleSeat.SEATS` and the `_log_grapple` kinds. Every row is either **shown correctly** or
**reported as not shown** — never faked with a wrong position.

| must be visible | today |
|---|---|
| standing engagement / clinch entry | **absent** (`grapple_clinch_engage`) |
| takedown | bound (double-leg entry) |
| throw | bound (body-lock start) |
| a SUSTAINED held position — at least `side` and `mount` | **absent** |
| `guard` and `half` as held positions | **absent** |
| `back` control | **absent** |
| a position change / pass | **absent** (`grapple_pass`, `grapple_position_change`) |
| sweep / reversal | bound |
| escape attempt | role exists (`grapple_escape`), check it resolves to a clip |
| stand-up | role exists (`grapple_stand_up`) |
| submission attempt | bound (armbar) |
| submission finish **with tap and release** | finish bound (strangle); **tap and release: verify, likely absent** |
| stall | deliberately unbound — leave it, and say so |

---

## 7. SAFE WORKSPACE

**Your worktree is yours alone: `C:/Users/user/AppData/Local/Temp/FightCamp-C134`, branch
`codex/c134-bjj-presentation`, cut from `origin/master`. No other agent is in it.**

**It is NOT pixel-clean, and that is expected — do not try to tidy it.** Warming the Godot import
cache for you rewrote about 1,000 `.import` files and extracted roughly 700 texture `.jpg` files
out of the `.glb` models. That churn appears in every worktree in this project, it is not yours,
and it must never be committed. **This is exactly why you stage explicit paths and nothing else.**

- **Do NOT rebase, and do not touch the main checkout** at `C:\Users\user\OneDrive\Documents\ChatGPT\Game`
  — it has hundreds of uncommitted `.import` files and other agents' work. You never need it.
- The Godot import cache has been warmed for you (3,121 files). If Godot ever hangs on a missing
  cache, re-run `--headless --path Godot --import` once with the `.godotbin\` binary.
- **`.godotbin/` is git-ignored. Never stage it** — it is 173 MB of Godot, not your work.
- Stage explicit paths only: `git add -- <paths>`, then **`git show --stat HEAD`** to prove nothing
  else rode along. Never `git add -A`. Never stage `AgentComms/messages`.
- Commit and push **`codex/c134-bjj-presentation`**. Claude merges.

---

## 8. VERIFICATION — FOCUSED, NOT THE WHOLE SUITE

### USE THE GODOT INSIDE YOUR WORKSPACE — `.godotbin\`, NOT the one in `%LOCALAPPDATA%`

**Your sandbox cannot execute a binary outside the workspace.** `%LOCALAPPDATA%\Programs\Godot\...`
fails with `Access is denied` — that is the sandbox, not a broken install, and it is why earlier notes
said Codex could not boot Godot. **Both Godot binaries have been copied into your workspace for you**
at `.godotbin\` (git-ignored, never commit them):

| use | path |
|---|---|
| headless / tests | `.godotbin\Godot_v4.7.2-stable_win64_console.exe` |
| windowed / recording | `.godotbin\Godot_v4.7.2-stable_win64.exe` |

Both are required — the console build launches the windowed one, so neither works alone.

**`python Godot/tools/run_tests.py` and `check_scripts.py` find Godot themselves and may hit the same
wall.** If they do, point them at your copy with `GODOT_EXE`, which overrides all of them:
```
set GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
```

**TWO STARTUP ERRORS ARE EXPECTED AND HARMLESS** — already verified in your sandbox:
`Failed to open log file for writing: user://logs/godot.log` and `Failed to read the root certificate
store`. Godot still boots, runs the script and exits 0. **Do not chase them.**

**Stage 0 gate — do this FIRST and report immediately if it fails:**
```
.godotbin\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_pair_live.gd
```
This has been run for you and it works: it printed `PAIR_LIVE_STATS` and exited 0. If it does NOT work
for you, **stop and say so in one line** — the whole acceptance depends on running Godot.

**Parse gate before any test**, on every `.gd` you touched — about a second each:
```
python Godot/tools/check_scripts.py <files>
```
A parse error HANGS a headless test until timeout instead of failing it.

**Focused tests only** (never the full suite — that is Claude's, once, at integration):
```
python Godot/tools/run_tests.py --only grapple
python Godot/tools/run_tests.py --only pair
python Godot/tools/run_tests.py --only stage
```
`SUITE total=N fails=M`; **exit code alone is NOT a pass** — a GDScript runtime error leaves rc=0.
`fight_pair_live` and `fight_stage_presenter_contract` are red on purpose; they are not yours.

**The watchable harness — this is how you SEE it and how you capture:**
```
.godotbin\Godot_v4.7.2-stable_win64.exe --path Godot --script tools/watch_live_room.gd -- seed=810039
```
It holds the fight, walks each man in, frames the camera from both skeletons every frame, and runs a
stopwatch. **To record**, add before `--script`:
```
--write-movie <file.avi> --fixed-fps 30 --quit-after <frames>
```
`tools/record_room.gd` is the other capture route. `tools/probe_pair_live.gd`,
`tools/measure_live_frames.gd` and `tools/measure_room_positions.gd` measure what you are seeing.

---

## 9. ACCEPTANCE

1. **A reproducible BJJ match from the intended game route**, not a bespoke demo scene — the room
   (`FightWorldLive` via `watch_live_room.gd`) with `discipline=bjj` and a named seed. Give the exact
   command. **This currently fails on the missing `grappling_mat` arena spec — fixing that is part of
   the job.**
2. **An MMA match** the same way, with the ground game visible.
3. **One continuous match** showing: standing engagement, a takedown, a sustained ground position, a
   transition, an escape attempt, and a submission with **tap and release**.
4. **Targeted demonstrations** for any required action that does not happen to occur in that match —
   a seed or a scripted beat sequence per action, each with its own command.
5. **Visual verification**, stated explicitly: the two fighters are synchronised; contact is
   believable; and there is **no obvious sliding, clipping, snapping or disconnected pose**. Name
   what you looked at and at which timestamps.
6. **A runnable entry point** and **a video capture** if the recording flags work.

---

## 10. HONEST COMPLETION — THE PART THAT MATTERS MOST

**Report missing coverage and visual defects explicitly.** A list of what is still absent, and what
looks wrong and where, is a SUCCESSFUL outcome of this task. Concealing it is the only failure.

- **Green tests do not establish that the animation is finished.** The suite is green right now on a
  ground game that is mostly invisible.
- **An unshown beat, named, beats a wrong clip.** The project's own ruling: *"a wrong position is
  worse than no clip."*
- If a position cannot be shown honestly, say so and leave it unshown.
- Where you author something, say it is authored and how, so nobody later mistakes it for bought film.

**Ask the operator only for decisions or purchases that materially change delivery.** Everything
else — which clip, which offset, which transition — is yours to decide and report.

---

## 11. SHIP

Commit your owned paths only, push `codex/c134-bjj-presentation`, then one line:
```
python Tools/agent_comms.py send --from codex --to claude --topic "C134 ready" --body "<one line>"
```
Digest to `research/C134_BJJ_PRESENTATION.md` — at most 150 lines: what you covered, what you
authored, what is still absent, the defects you saw, and every command needed to reproduce the two
matches. Do NOT edit `HANDOFF.md`.

## The trap specific to this task

**The engine is not yours and the presentation is.** When a ground exchange looks wrong, the first
instinct is that the simulation chose badly. It usually did not — the engine's ground game is
measured and works; the room simply has no film for what it chose. **Fix the presentation, report the
engine.** And when you cannot show a beat honestly, the answer is to say so, not to reach for the
nearest clip.
