# THE FIGHT IS SILENT. BUILD THE SOUND.

**LONG-RUNNING TASK — it does not finish in one pass.** Operator ruling
2026-09-22: agents hold standing work and are checked every session.
**Owner:** qwen (`qwen3-coder`, medium, `--yolo`, shell in this checkout).

## Where this starts, measured 2026-09-22

- `Godot/assets/audio/` holds **ONE file**: `unbreakable_noise_menu.mp3`.
- `Godot/scripts/` contains **NO audio script at all** — no mixer, no bus
  layout, no player, nothing. `ls scripts/ | grep -iE 'audio|sound|sfx'`
  returns empty.
- So a fight is silent, and the menu has a track.

**THE RESEARCH IS ALREADY DONE — DO NOT REDO IT.**
`research/J22_WHAT_A_FIGHT_SOUNDS_LIKE.md` is John's study of what a real
fight sounds like. Read it before you design anything, and build what it
already established rather than inventing a sound design from scratch.

## The standing objective, in priority order

1. **The bus layout and one playable hit.** A `FightAudio` autoload or module
   with buses (master / sfx / crowd / music), and ONE strike landing with a
   sound at the right moment. The moment is the hard part, not the file.
2. **Hook it to the beats that already exist.** `FightBeatAdapter` emits a beat
   per action with `landed`, `outcome`, `technique`, `target_region` and
   `grade`. That is a complete score for sound and nothing reads it. A landed
   head strike and a blocked body strike must not sound the same.
3. **The ground.** 49.5% of grapple events are `grapple_control`. Breathing,
   effort, mat friction - the things that make a hold read as work rather than
   as two men lying still.
4. **The room.** Crowd bed that reacts to `grade`, corner voices, the bell,
   the ten-second clapper.

## Rules that are not negotiable

- **NO PURCHASED OR DOWNLOADED AUDIO** without the operator's explicit word.
  Generate, synthesise, or use what is already in the repo. A sound you cannot
  license is worse than silence.
- **NEVER stage `audio_exports/`.** It is in the commit rules for a reason.
- **The timing comes from the engine, not from a timer you invent.** A strike's
  contact moment already exists in the schedule; find it and use it. A sound
  played 80 ms late reads as a different fight.
- Zero new dependencies.

## Every pass ends with an ARTEFACT THE OPERATOR CAN HEAR

A silent commit is not a delivery. Produce a short recording with sound - the
room records with `tools/record_room.gd`, and `--write-movie` captures an audio
stream alongside the video. Commit it, and say in one line what changed.

**And say what is still wrong.** A pass claiming the sound is finished is the
one that gets checked hardest.

## Gate

```
python Godot/tools/check_scripts.py <each .gd you touched>
python Godot/tools/run_tests.py --only audio    # make this exist if it does not
```

Do NOT fetch or rebase; the checkout is shared and current. Never `git stash`,
`reset --hard` or `add -A`. Stage explicit paths.

---

# PASS 2 — RE-CUT 2026-09-22 BY CLAUDE. THIS IS YOUR CUT. START HERE.

**Do not restart from the top of this file. Pass 1 landed (7f62b4e4) and was
then repaired here (550f71e4). This section is the only thing you build.**

## WHAT PASS 1 LANDED, AND THE TWO THINGS THAT WERE WRONG WITH IT

`Godot/scripts/FightAudio.gd` is a real autoload: Master/SFX/Crowd/Music buses,
four generated impacts, an eight-player pool, and an `on_beat()` seam both
fight screens call after `advance_beat()`. That shape is right and it stays.

**Two defects were found here AFTER your 43 checks came back green. Read both,
because pass 2 must not repeat either shape.**

1. **Godot's `AudioStreamWAV.FORMAT_8_BITS` is SIGNED int8, not unsigned
   0..255.** The generator wrote `(f * 0.5 + 0.5) * 255`, which maps SILENCE
   (f = 0) onto 127 — full-scale positive DC. So every impact's exponential
   decay tail sat PINNED AT FULL SCALE instead of fading: measured tail mean
   |s| = **127.0 of 127** on all four presets. It was a click, not an impact.
   The encode is now `int(roundf(clamped * 127.0)) & 255`.
   `Godot/tools/probe_wav8.gd` is the probe that settles the format question —
   run it if you ever doubt a sample format again, do not reason about it.
2. **The test's beat routing was a COPY of `_route_beat` living inside the
   test file**, so it only ever agreed with itself. Mutating the router to
   send EVERY beat to `"miss"` left it at `total=43 fails=0`. It now calls the
   real `_route_beat` and reads back `FightAudio.last_played`, which is
   recorded BEFORE the headless guard so a headless run can observe the real
   decision. **A GATE THAT RE-IMPLEMENTS ITS SUBJECT CANNOT FAIL. Derive every
   expectation in pass 2 from the module you are testing.**

Current clean number: `tests/fight_audio_test.gd` is **total=51 fails=0**, and
it bites — 5 fails on the routing mutant, 4 on the encoding mutant.

## WHAT YOU BUILD IN PASS 2: THE CROWD, AND THE TIMING BUDGET AS A NUMBER

John's pass 2 study landed today at
`research/J22B_WHAT_A_FIGHT_SOUNDS_LIKE_PART_TWO.md`. **Read it before
you design anything.** It is the source for every number below and it is the
only research you need to open.

### 1. The crowd bed on the Crowd bus

A fight with four impact sounds and silence between them is not a fight. The
crowd is the bed everything else sits on, and it is the single largest thing
missing. Generate it the same way the impacts are generated — **synthetic PCM
at startup, no purchased or downloaded audio** — and give it at least:

- a **base bed** that is always there while a round is live, and
- a **swell** that rises on a significant moment and falls back.

J22B names one cue explicitly, `crowd_near_finish`, and it deliberately gives
NO millisecond figure for it. **Do not invent one.** Drive it off state the
engine already has, not off a timer you made up.

### 2. The sync budget, enforced by a test rather than asserted in a comment

This is the half that makes the crowd worth having, and J22B gives it to you
as measured numbers:

- fire on **contact**,
- a sound may **lag** contact by at most **80 ms**,
- it may **lead** contact by at most **45 ms**,
- cage time-of-flight is far under 80 ms — **do not pad to 80 because you
  have 80**. The budget is a ceiling, not a target.

`FightBeatAdapter` gives you the beat. Write a test that takes a real beat
sequence and proves the audio decision happens within that window of the beat
it belongs to — and that it is attributed to the RIGHT beat. Print the
achieved offset beside the wanted one; "it is in budget" is not a finding
until the number is on screen.

### 3. Breadth, only if 1 and 2 are done

A landed head strike, a blocked body strike and a miss must already not sound
the same — that shipped in pass 1. The next real distinction is **grade**: a
grazing hit and a hurt-him hit are the same sound today. Use the `grade` field
the beat already carries.

## GATE — TIER: FOCUSED, NO SUITE RUN

1. `python Godot/tools/check_scripts.py <every .gd you touched>` FIRST. A
   parse error does not fail a headless test, it HANGS it.
2. `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script
   tests/fight_audio_test.gd` — must stay at **fails=0** and the total must go
   UP, not sideways.
3. `python Godot/tools/run_tests.py --only fight_audio` and
   `--only fight_beat`.
4. **DO NOT RUN THE FULL SUITE.** That is Claude's, once, at integration.

**PROVE YOUR OWN GATE WITH MUTANTS BEFORE YOU BELIEVE IT.** Break the thing
you just built in three or four different ways, confirm the test goes red each
time, restore it, confirm green. Put the mutant table in your digest. A green
test you have not tried to break is not evidence — pass 1 is the proof.

## TRAPS SPECIFIC TO THIS PASS

- `play_hit` early-returns under `DisplayServer.get_name() == "headless"`, so
  **nothing you can hear happens in a test.** Anything you want a test to
  observe must be recorded BEFORE that guard, the way `last_played` is.
- A crowd bed is long. Generating many seconds of PCM per-sample in GDScript
  at startup costs real boot time — measure it and say what it costs. If it is
  slow, loop a short generated segment rather than generating a long one.
- Do not add a top-level `preload` of a scene script to `smoke_test.gd`.
- Commit with explicit paths (`git add -- <files>`), never `git add -A`, and
  never `git stash` / `reset --hard` / `checkout .` in this shared checkout.

## WHAT TO SEND BACK

A digest at `research/Q135_DIGEST.md`: what landed, the achieved-beside-
wanted timing table, the mutant table, the real test numbers, and the ONE
thing you would do next in pass 3. Then
`python Tools/agent_comms.py send --from qwen --to claude --topic "SOUND PASS 2"`
with one line. **Do NOT edit `HANDOFF.md`.**

---

# PASS 3 — RE-CUT 2026-09-22 BY CLAUDE. THIS IS YOUR CUT. START HERE.

**Pass 2 landed (`769b03d0`) and it is good work.** The crowd bed is on the
Crowd bus with `start_crowd()` / `stop_crowd()` / `crowd_swell(intensity)`,
grade now routes significant strikes to harder presets, the sync budget prints
`achieved` beside `wanted` on every beat, and the gate went 51 -> 103 checks
with four mutants confirmed red and restored green. That is exactly the shape
asked for.

## ONE DEFECT CAME OUT OF PASS 1 AND ONLY THE INTEGRATOR'S SUITE COULD SEE IT

`FightNightScreen.gd:522` called `FightAudio.on_beat(event)` using the **bare
autoload identifier**. A scene script is compiled BEFORE the autoloads are
registered, so the moment another agent's new test preloaded
`FightNight.tscn`, that line was a hard compile error — `Identifier not found:
FightAudio` — and took `--only corner` to fails=1.

**You could not have caught it and neither could they.** Your own test never
loads the scene; their test was written against a contract, not against your
branch. It is fixed here (`4f40de75`) with a preloaded script const, because
`on_beat` is static and finds the live autoload itself through the scene tree.

**THE RULE TO CARRY: never write a bare autoload identifier in a scene
script.** Use `get_node_or_null("/root/<Name>")` plus `has_method`, or preload
the script. This is in `CLAUDE.md` and it costs a fix cycle every time.

## WHAT PASS 3 DELIVERS — YOUR OWN NEXT STEP, PLUS THE HALF THAT MAKES IT REAL

**1. WIRE THE CROWD IN.** You named it: `start_crowd()` / `stop_crowd()` at
round boundaries in `FightNightScreen` and `FightWorldLiveScreen`. Today the
crowd bed exists and nothing starts it, so the fight is still silent in the
room. Do this first — it is the difference between a module and a feature.

**2. MAKE THE CROWD REACT, NOT JUST EXIST.** `crowd_swell(intensity)` needs
something to drive it. John's J22B named the one cue it is prepared to stand
behind, `crowd_near_finish`, and deliberately gave NO millisecond figure for
it. Drive the swell off state the engine already has — a knockdown, a
significant strike, a finish sequence, the last seconds of a round — and NOT
off a timer you invented. Where you need a number nobody has measured, say so
in the digest rather than picking one.

**3. THE ROUND BELL AND THE BREAK.** A round that starts and ends with no
sound is the single most obvious remaining hole once the crowd is in. J38 (
`research/J38_THE_CLINCH_BREAK.md`) has the measured clinch-episode
figure — 4.06 +- 2.27 s, Martusciello 2025 — and notes the referee break has
written criteria but NO numbered seconds in the Unified rules. Use what is
measured; do not invent what is not.

## GATE — TIER: FOCUSED, NO SUITE RUN

1. `python Godot/tools/check_scripts.py <every .gd you touched>` FIRST.
2. `tests/fight_audio_test.gd` — it is at **103 checks, 0 fails**. Stay at 0
   and let the total rise.
3. `python Godot/tools/run_tests.py --only fight_audio`, then `--only corner`,
   then `--only ui`. One `--only` per invocation. **You are touching the two
   fight screens, which is exactly where the last defect lived, so `--only
   corner` is not optional this pass.**
4. NO FULL SUITE — that is Claude's, once, at integration.

**Keep proving your gate with mutants; four caught last pass and that is why
this one can build on it.**

## WHAT TO SEND BACK

`research/Q136_DIGEST.md`: what landed, what drives the swell and what
state it reads, the mutant table, the real numbers, and any figure you wanted
and could not source. Then
`python Tools/agent_comms.py send --from qwen --to claude --topic "SOUND PASS 3"`.
Do NOT edit `HANDOFF.md`.
