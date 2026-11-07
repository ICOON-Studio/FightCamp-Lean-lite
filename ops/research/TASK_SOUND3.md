# TASK_SOUND3 - the sound engineer, round 3: a real room, sized by the crowd (Qwen)

Model: Qwen (qwen3-coder). Discipline: boxing. Repo: E:\FightCamp\Lean, on your own worktree and branch. Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only (`--headless --audio-driver Dummy`), nothing opens on the operator's screens.
Start after SOUND2 is merged.

## Contract
OWNS: scripts/audio/, assets/audio/, tests/crowd_room_test.gd
RED_TEST: tests/crowd_room_test.gd -> CROWD_ROOM failures=0
REGRESSION: sound_bank_test, attendance_test
VISUAL: no

## The operator heard it (S395)
"the sound for first time i heard was pretty good, i just want it to get a bit better, the miss sound needs to be better implemented
or removed and small things like that to make it like an arena according to the attendance as real as possible".
His ear is the rating. Keep what he heard; do not rebuild it. This is polish, in small steps.

## Do, in this order
1. **Miss sound.** One whoosh plays on every miss and it stands out. Make it quiet and rare: only a full power punch that misses
   makes a whoosh, well under the punches, a jab or a slipped shot stays silent. If it still stands out after that, remove it and
   say so in the notes.
2. **The room by attendance.** `scripts/rules/Attendance.gd` gives `of(bout)`, `room(people)` and `share(people)`. Scale from it:
   - the crowd bed's level and density: a 220-person hall is single voices and a thin murmur; a 12,000 arena is a wall of sound;
   - the room: a short, dry reflection in a hall, a long wide tail in an arena, on the Room bus, on punches and the bell;
   - the roar: a hall claps and shouts, an arena erupts.
   The bout is on `f["bout"]` when the fight starts; add one call from the existing bell path, as small as you can.
3. **Crowd that follows the fight.** Small things only: a rise on a run of landed shots, a groan on a knockdown of the home fighter,
   a hush in the last 10 seconds of a close round, a swell at the end-of-round bell. Bigger crowds react more.
4. **Corner minute.** The crowd drops under the coach's voice space and comes back for "Seconds out".

## Done
Measured before and after for each step in `assets/audio/SOUND_QA_S395.md`, plus one short note of what the operator should listen
for. Touched tests pass; do not run the full suite. Any new sound goes on the sound board for his ear and stays unused until he has
heard it. Open a PR. Do not claim a score.
