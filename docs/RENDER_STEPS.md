# Puncher's chance on Render - your steps (S567)

Owner S567: "make it public with render so he doesnt need tailscale".

## LIVE since 2026-11-27: https://punchers-chance-test.onrender.com
The owner signed in to Render in Claude's browser and said "do the rest": Render's GitHub app was installed on ICOON-Studio
with access to ONE repo (punchers-chance-test), the Blueprint was created (name punchers-chance-test, Free plan) and the
first deploy went live in 43 seconds. Checked from outside with no code: /healthz answers; every other address (a page, a
picture, version.js, the table, our server files) returns only the sign-in page; the match calls answer 401; a wrong code
is refused; plain http is sent to https. The signed-in path was tested on this PC from the same built copy (12 of 12), not
on the live address: the owner's first sign-in is that test. "Your part" below is DONE and kept for the record.

## What is ready
- A private GitHub repo, https://github.com/ICOON-Studio/punchers-chance-test : only the BUILT copy of the game and our
  small server (62 MB, 4,136 files). The main repo is not connected to Render and stays as it is.
- The server asks every visitor for a personal code, then shows the confidentiality notice once, and only then serves the
  game. Before that it serves nothing of the game: no page, no picture, no script. Tested on this PC: 12 of 12 checks.
- Playing each other works at the same address (the match server is inside).
- Three codes exist: owner, brother, friend. They are in `proto/twohands/site/data/tester_codes.json` on this PC (a folder
  git ignores). Only their hashes are in the repo. Open that file to read them; send each person his own.

## Your part (about five minutes; Claude never types your Render or GitHub password)
1. Open https://dashboard.render.com and sign in.
2. New (top right) -> Blueprint.
3. Connect GitHub if it asks, and give Render access to ONE repo: ICOON-Studio/punchers-chance-test.
4. Pick that repo. Render reads its `render.yaml`: one web service, "punchers-chance-test", plan Free. Press Apply / Deploy.
5. Wait for "Live" (a few minutes). The address is shown at the top, like `https://punchers-chance-test.onrender.com`
   (Render adds letters if the name is taken). Tell Claude the address.

## For a tester
Send him the address and HIS code. He types an email and the code, presses I agree once, and lands on the Play online
page. He needs nothing installed.

## What to know
- FREE PLAN: the service sleeps after about 15 minutes with no visitor and takes up to a minute to wake on the next
  visit. A bout in progress keeps it awake. Check Render's current free-plan terms when you create it.
- THE LOG: `<address>/owner/log` (signed in with the owner code) lists who signed in, who agreed and which pages were
  opened - since the last restart. A free service's disk is wiped at every restart and deploy, so every line is ALSO
  printed to Render's own log (Dashboard -> the service -> Logs), where it stays. A lasting list on the page needs a paid
  disk or a database: your call, not set up.
- MATCH RESULTS and the online table are wiped at a restart for the same reason.
- THE EMAIL a tester types is recorded, not checked: the CODE is what proves who he is. One code, one person.
- A NEW TESTER: `python proto/twohands/tools/make_site.py E:/FightCamp/tmp/punchers-chance-test --tester <label>`, commit
  and push that folder. TO END SOMEONE'S ACCESS: take his label out of `tester_codes.json`, run make_site.py, push.
- A NEW VERSION of the game reaches the public address only when Claude rebuilds and pushes the copy (make_site.py, then a
  push to the test repo = a deploy). The Tailscale link keeps showing the live folder as before.
- TO TAKE IT DOWN: Render dashboard -> the service -> Settings -> Suspend (or Delete).
- The notice's words are the ones you approved for the Tailscale link (notice version 1).
