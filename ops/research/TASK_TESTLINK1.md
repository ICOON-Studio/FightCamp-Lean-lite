# TASK TESTLINK1 - a test link for Puncher's chance: email sign-in, a confidentiality step, a log of who played (S565)

Kind: build (hosting + a small gate). Model: Claude (the lead; needs the browser for the host's dashboard).
Discipline: boxing (Puncher's chance, the browser pages). Estimate: 2-3 hours once the account exists.

## His words (S565)
"how can i get my brother a link to test the game ?" - then, asked public or temporary:
"make it public but ask for email (maybe nda proof ) when someone sign ins and you keep a log of who uses the link ?"

## What he gets
One address that works with his PC off. A visitor types his email, gets a one-time code by email, accepts a short
confidentiality notice once, and plays. The owner sees a list: who signed in, when, which page, which version, and who
accepted the notice (with the notice's version and time).

## Why not the simple ways
- A static site (GitHub Pages) cannot check an email or keep a log; a form drawn by the page itself is skipped by
  anyone who opens the picture folder directly. The gate must sit in front of the files, on the host.
- The main repo is private and stays private. Only `proto/twohands` (pages, scripts, pictures, the two look-ahead
  tables) is published, as a built copy.

## Design (decided; CHANGED the same day: he said "i use render / onrender" - the host is RENDER, not Cloudflare)
1. HOST: a Render WEB SERVICE (onrender.com) running one small Node server of ours. A Render static site cannot check
   an email or keep a log, so it is a web service: `server.js` (Node's own http module, no framework) serves the built
   copy and stands in front of every file.
2. WHERE RENDER READS IT FROM: a NEW PRIVATE repo, `ICOON-Studio/punchers-chance-test`, holding only the built copy +
   server.js + render.yaml (a Blueprint: he picks the repo once in his Render dashboard). The main repo is never
   connected to Render and stays private. A push to that repo is a deploy.
3. SIGN-IN: email + a PERSONAL CODE. Claude makes one code per tester (stored hashed); he sends his brother the address
   and the code. No email-sending service is needed, and only the person he gave the code to can be that email in the
   log. (A code sent by email at sign-in needs a mail service account on top - offer it, do not assume it.)
   Session = a signed cookie (HMAC, secret in a Render environment variable), 30 days.
4. THE CONFIDENTIALITY STEP: no acceptance on record for this email and this notice version -> `nda.html` (the notice,
   one button "I agree"); the POST stores {email, notice version, time, a hash of the notice's text}.
5. THE LOG: every page load (not pictures or scripts) stores {email, time, page, game version}. `/owner/log` (his own
   code): two plain tables, newest first, and a CSV download. STORAGE: a Render web service's own disk is wiped on every
   deploy, so the log goes to a database - check Render's CURRENT terms before choosing (a free Postgres there has had a
   time limit; a paid disk or database is his money call). Fallback that costs nothing: append the log to a file in the
   private test repo through the GitHub API (a token in a Render environment variable).
6. THE NOTICE: a short plain-words confidentiality notice (unreleased game, do not share the address, the code,
   screenshots or recordings; feedback welcome). Claude drafts it; HE approves the words. Say plainly: a click with an
   email and a time is a record that he agreed, not legal advice. The sign-in page says what is recorded.
7. THE BUILD COPY: `python proto/twohands/tools/make_site.py <checkout of the test repo>/site`: order, head, kick,
   punch, wait, changelog + version.js, ring_ui.js, body_ui.js, vtable.json, vtable_wait.json, img/, the sounds the pages
   load. NOT: tools/, switch.html, index.html, any *.md, any tweak file. It prints the file count and size and fails on
   a missing file a page asks for (read each page's src / fetch / frames.json).
8. THE VERSION: the site shows the same `v0.<session>.<n>`; from then on every page change ends with make_site.py and a
   push to the test repo, and the changelog line is the proof of what a tester played.

## THE TAILSCALE WAY (he asked the same day: "or can you do it via tailscale ?") - the same server.js, another front door
Checked S565: Tailscale 1.104.6 is installed and signed in on this PC (machine `beast`, tailnet `tail6f2f5c.ts.net`,
his iPhone is on it). It already serves tcp 9791 -> 127.0.0.1:9792 for something else: NEVER touch that entry.
- `tailscale serve --bg --https=8443 http://127.0.0.1:<the gate's port>` gives `https://beast.tail6f2f5c.ts.net:8443/`,
  reachable only by people on his tailnet or people he SHARES the machine with (his brother installs Tailscale and
  signs in with his own account; the owner sends the share invite from the Tailscale admin page himself).
- Tailscale tells our server who is asking (the `Tailscale-User-Login` header on served requests): the gate needs no
  code, the log has a verified identity, the notice step is the same page.
- Nothing is stored on the web. It works only while this PC, the page server and the gate run.
- CAUTION to tell him: sharing a machine lets the guest reach it on every port his Tailscale rules allow, not only the
  game. Before the invite, an access rule must limit the guest to port 8443 (his admin page; say exactly what to click).
- `tailscale funnel` (public, no sign-in by Tailscale) is the "temporary link" with our email + code gate in front.
- Adding a serve entry changes his Tailscale setup: do it only on his plain yes.
So server.js has two identity modes: `tailscale` (the header) and `code` (email + a personal code, for Render).

## STATE AT THE END OF S565 - he chose "Tailscale"; the gate is BUILT and LIVE on his own tailnet
- `proto/twohands/site/server.js` (the gate, Node only), `notice.txt` (version 1, APPROVED by him in S565: "Yes, use them"), `server_test.mjs` (GATE_TEST 7 passed), `run_gate.ps1` (reads the owner's login from Tailscale: no email in the
  repo), `data/` (the two lists, git-ignored).
- Running: terminal tab "gate565" of the S565 session (`powershell -File proto/twohands/site/run_gate.ps1`, port 8798,
  127.0.0.1 only). It dies with that session's app: a new session starts it again (later: a scheduled task).
- Tailscale: `tailscale serve --bg --https=8443 http://127.0.0.1:8798` ADDED (tailnet only):
  https://beast.tail6f2f5c.ts.net:8443/ . Remove with `tailscale serve --https=8443 off`. His other serve entries
  (tcp 9791, https 443 -> 8791 with /blood-senate, http -> 8788) were not touched.
- Checked from this PC through that address: the owner gets the game without the notice, a picture and wait.html load,
  /owner/log lists the visits, a file before agreeing is refused (403), a request not through Tailscale is refused.
- DONE after that: his OK on the notice. Tailscale's docs read: docs/TESTLINK_INVITE_STEPS.md (the one-port rule with
  autogroup:shared, the Share clicks; a shared guest's login DOES reach the gate per the Serve page).
- NOT DONE: (2) the invite to his brother - HE sends it from his Tailscale admin page;
  (3) BEFORE the invite, a rule that limits a shared guest to port 8443 only: sharing the machine would otherwise also
  open his other served pages (443, 80, 9791) to the guest. READ TAILSCALE'S DOCS for the exact rule (the shared-users
  group in the access rules) and the exact clicks - do not write it from memory; (4) UNVERIFIED: that Tailscale passes a
  SHARED guest's login to the gate (if it does not, the gate refuses him - a safe failure - and the code sign-in mode
  is the fix); test with his brother's first visit and read /owner/log; (5) make_site.py and the Render way: not built.

## What only the owner can do (asked in chat)
- In his Render dashboard: New > Blueprint, pick the test repo (GitHub asks HIM to let Render see that one repo), Deploy.
  Claude never types his Render or GitHub password.
- The instance: free (it sleeps when nobody plays; the first open can then take about a minute) or a paid always-on
  one - his money.
- The testers' emails; his OK on the notice's words.

## Feedback loops
None: hosting and a log; no game rule changes.

## Not allowed
Nothing goes on the web before he has said yes to the notice and the list and has connected the test repo himself. No file outside the
build copy is published. No analytics or third-party script on the pages. The log holds email, time, page and version
only. The main repo's visibility is never changed.

## Contract
- OWNS: proto/twohands/tools/make_site.py, proto/twohands/site/server.js, proto/twohands/site/nda.html,
  proto/twohands/site/signin.html, proto/twohands/site/render.yaml, proto/twohands/site/server_test.mjs, docs/TESTLINK1_RESULT.md
- RED_TEST: none (today there is no link at all)
- REGRESSION: page_parse.mjs on the five pages; page_play_test.mjs 4 passed on order.html
- VISUAL: the sign-in page, the notice and the owner's log opened in the browser; a second email account walks the
  whole path (code, notice, play) and appears in the log

## Result
`docs/TESTLINK1_RESULT.md`: the address, how he adds a tester, where the log is, how a new version gets there, what is
recorded. End with `TESTLINK1 DONE` or `TESTLINK1 BLOCKED: <why>`.

## Prior research
None in our notes (first time a build leaves the PC). memory feedback_changelog_version_s565.

## What would a human do?
A small studio puts a closed test behind an email sign-in on its host, shows a one-page confidentiality notice, keeps
the access log the host already makes, and sends each tester the same address.

## Prefab check
Render (his host) runs it; the gate is about 150 lines of our own Node with no package to install, tested on the PC
(`node proto/twohands/site/server.js` + server_test.mjs: no code = no file, a wrong code = no file, the notice once,
the log rows) before anything is pushed.
