# bjj-video-analyzer.com (S494, link from the operator)

What it is: a small-team beta (v0.50) web app. Upload BJJ training video (MP4/MOV/AVI, under 2 GB) -> AI detects techniques
with timestamps, a position timeline, a transcript, tag suggestions; manual tags fix misses ("better lighting/angle" when
nothing is found). Invite-gated: Free 5 uploads, Supporter $3/month 15 uploads (+ a Gemini analysis tab). Has a login-only REST
API (techniques, positions, position-transitions, technique-breakdowns, timestamps, transcripts), a "Partner API" page and an
"AI Connect" page (Claude / Cursor / VS Code) - neither read yet. No terms or licence page found: treat its library text and
data as all rights reserved (reference only, never copied into the game).

Technique library: 230 techniques, grouped Phase (Standing / Transitional / Ground) -> Position (Mount, Side Control, ...)
-> Mechanic (~40: judo-style groups like Kansetsu-waza, Shime-waza, Osaekomi-waza, Ashi-waza plus Underhook, Overhook, Base,
Pressure, Sweep, Guard Passing, Escape, Turnover...). An entry: one-line description, other names by system, when it is used,
risk flag ("High risk" on Banana Split, Buggy Choke), see-also and related techniques.

Use for FightCamp:
- Structure reference for our BJJ fighter's move set: Phase -> Position -> Mechanic plus a position-transition graph is a good
  shape for the grappling playbook (the boxing Playbook is moves -> combos). Write our own entries.
- For the boxing video analyzer session (ops/Tools/fight_video): a working example of the product shape for grappling
  (position timeline + technique markers); it does nothing for boxing.
- Testing it on footage means uploading video to their servers: the operator's call, his own clips only.
