# TASK K55 — KALLI — A WATCH LIST: YOUTUBE VIDEOS WHERE THE PUNCHES CAN BE STUDIED FRAME BY FRAME

Owner: Kalli (research, no shell). Stage: S4a (the operator's "punches look fake" and "bodies overlap"). Deliver as ONE
markdown answer.

## Why this exists

The operator, 2026-09-14: "watch YouTube videos and learn the moves". Lab studies do not measure a jab the way a game
needs it, so Claude will watch real boxing on YouTube in a browser, step the video frame by frame, and read off how the
body really moves: whether the front foot steps in a jab, how far the head and hips travel toward the opponent (in
shoulder widths and stance lengths, not centimetres), how long the punch takes in frames, how far apart the men stand,
where the glove lands and how the other man's head moves. That only works on the RIGHT footage, and finding it is this
task.

## What makes a video usable

- The WHOLE body of the puncher is visible, feet included, for the whole punch.
- The camera is roughly SIDE-ON to the line between the two men (or to the heavy bag / mitts), and does not move or cut
  during the punch.
- Real speed at 50-60 fps, or slow motion; clear footage (720p or better).
- Best: two men in real sparring or a real bout, filmed side-on (amateur bouts, gym sparring filmed from ringside,
  broadcast replays in slow motion). Also useful: a coach demonstrating the technique side-on on mitts or a bag, and
  slow-motion technique breakdowns.

## What to find (with timestamps)

For EACH of: jab, stepping jab, cross, lead hook, rear hook, uppercut, body shot, slip, block/parry, a boxer moving in
and out of range, two boxers in the pocket with their gloves touching - 2-3 videos, each with:
- the full URL, and a timestamp (`?t=` seconds) where a clean example starts,
- what is on screen (sparring / bout / mitts / bag / demonstration; who, if named),
- camera angle and whether the feet are visible,
- real speed or slow motion, and the frame rate if YouTube shows 60 fps.

## Format

Start the answer with the line `Collect as: K55_WATCH_LIST.md`. Then a markdown file whose first line is a `# ` title,
then one table per technique (URL with timestamp | what is on screen | angle and feet | speed), then a short list of the
five BEST videos overall for frame-by-frame study, best first. Only list videos you found and could open; no guesses.
