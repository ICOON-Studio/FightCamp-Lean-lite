# FightCamp Ops Board

Local web dashboard for who is working, on what, for how long, whether they
stay in rotation next session, and the live roadmap (now / next / stages /
sessions / assessment).

## Start

From the repo root:

```bash
python Tools/opsboard/server.py
```

Default port is **8787**. Override with `--port N`.

On startup the server prints:

* `http://127.0.0.1:8787/` for this PC
* `http://<pc-lan-ip>:8787/` for Safari on an iPhone on the same LAN

It binds `0.0.0.0`. No Flask, no npm, no CDN, no internet required.

## Roadmap sections (source of truth)

The board reads **`AgentComms/roadmap.json`** only. That file is the single
source of truth; `ROADMAP.md` is generated from it by `Tools/render_roadmap.py`.
The board does **not** hand-copy titles, percentages, or blocked questions into
HTML or Python — the server loads the JSON into `/api/snapshot` (and
`/api/roadmap`) and the page renders whatever it is given.

If the JSON is missing or unparseable, the rest of the board still loads and
the page says plainly that the roadmap could not be read.

Sections, in page order below Suite status and above Usage / History:

1. **Now / Next** — `roadmap.now` and `roadmap.next` (loudest cards; first
   thing after suite on a phone)
2. **Waiting on you** — `roadmap.blocked_on_operator` (hidden when empty)
3. **Roadmap** — `roadmap.stages` with judgement progress bars; `done_when`
   collapsed by default on a phone
4. **Sessions** — `roadmap.sessions` (in_progress marked; planned de-emphasised)
5. **Where the game is** — `roadmap.assessment` one-liner, bars, and the
   `assessment.source` attribution beside them (these percentages are
   judgement, not measurement)

Then the original agent Now / Attention / Usage / History sections follow.

Phone rule: no horizontal scrolling at 390pt. Prefer fitting the screen over
showing every detail — full text lives in `ROADMAP.md`.

## The Windows .exe

`FightCampOpsBoard.exe` at the repo root is the same server frozen with
PyInstaller, so it runs with no Python install and no arguments - double-click
it. `index.html` rides inside the exe; the repo is found by walking up from
the exe's own folder, so **keep the exe at the repo root** (or set
`FIGHTCAMP_ROOT` to the checkout).

**`index.html` does NOT need a rebuild; `server.py` does.** R138 makes the
checkout's page win over the bundled copy (see `_resolve_paths`), so a pulled
page is served by the running exe immediately - while the frozen `server.py`
inside it stays whatever it was at build time. That asymmetry is what made the
2026-09-15 launch button invisible: the page had it, the exe had no
`/api/launch`, and the page hid the section instead of saying so. It says so
now, but the rebuild is still what makes the endpoint exist.

**YOU CANNOT OVERWRITE A RUNNING .EXE ON WINDOWS**, and the scheduled task
relaunches this one every five minutes, so a bare PyInstaller call fails with a
permission error or gets raced. Disable the task, kill the process, rebuild,
re-enable - in that order:

```powershell
Disable-ScheduledTask -TaskName 'FightCamp Ops Board'
Stop-Process -Name FightCampOpsBoard -Force -ErrorAction SilentlyContinue
python -m PyInstaller --onefile --noconfirm --name FightCampOpsBoard --add-data "Tools/opsboard/index.html;." --distpath . Tools/opsboard/server.py
Enable-ScheduledTask -TaskName 'FightCamp Ops Board'
Start-ScheduledTask  -TaskName 'FightCamp Ops Board'
```

**Or stop rebuilding forever: `SetUpOpsBoardButton.cmd` in the repo root.** One
double-click: it merges the pushed branch into this checkout (refusing on a
dirty tree, aborting a conflicting merge), then does everything
`UseSourceBoard.cmd` does. It exists because the operator is never at this PC
when a change is pushed, and **nothing on the machine pulls** - every command
the frozen board can run is read-only (`tasklist`, `git log`, `git show`,
`agent_comms.py board`, `triage --no-fetch`), so a page can never add the
endpoint a launch button needs. One visit has to do the lot.

**Or, without the merge: `Tools/opsboard/UseSourceBoard.cmd`.** Double-click
it once on the PC. It registers a SECOND scheduled task that runs this
`server.py` from the checkout on port 8788, with the same self-healing
five-minute trigger, and **leaves the exe and its task on 8787 completely
alone** - if it fails you have lost nothing. It verifies the new board answers
`/api/launch` before declaring success and unregisters itself if it does not.

Re-run it with `-Replace` once you trust it and the ORIGINAL task moves to the
source too, so 8787 gets the button and there is one board again; its definition
is exported to `_main_task_backup.xml` first and restored automatically if the
source board does not come up. `-Undo` puts everything back.

After that the board is the checkout: `git pull` updates the page AND the
server, and the page/server drift that hid the launch button for two rounds
cannot happen again.

Ad-hoc, without touching any task:

```powershell
python Tools/opsboard/server.py --port 8788
```

The exe is a build artifact and is NOT committed.

## Run on this PC (operator ask, 2026-09-15)

`POST /api/launch` starts something on the PC the board is running on, and the
board's **Run on this PC** section is a button per target. It exists for one
situation: the Claude desktop app has crashed and the operator is holding a
phone. The board is a scheduled task that heals itself every five minutes, so
it is up when the app is not - which makes it the only thing on the PC a phone
can still reach.

**The request carries a target NAME and nothing else.** Every path that gets
executed lives in `AgentComms/launch_targets.json`; a `path` or `args` key in
the body is ignored. The board binds `0.0.0.0` with no authentication - that is
how the phone reaches it - so an endpoint that ran what it was told would be a
remote shell for anything else on the Wi-Fi. **Adding a target is a commit.**

```bash
curl -s http://127.0.0.1:8787/api/launch                      # what each button will do
curl -s -X POST -H 'Content-Type: application/json' \
     -d '{"target":"claude"}' http://127.0.0.1:8787/api/launch
```

`GET` resolves each target before it is pressed, so a target whose app has moved
shows as not-ready on the phone **with every path it looked in**, rather than
failing only on the tap. Resolution is the `candidates` list first, then a
depth-bounded walk of `search.roots` - an installer that churns
version-numbered folders still gets found. A `.lnk` is launched through
`explorer.exe`, because `Popen` cannot run a shortcut without a shell and
turning the shell on would hand this endpoint a command line.

Non-Windows boards say so and refuse; nothing is attempted.

**The .exe must be rebuilt for this to appear** (see the rebuild command
above) - or run `python Tools/opsboard/server.py` directly while you are at the
PC. The button then starts the app; type `/remote-control` in its prompt box to
drive the PC from the phone.

## Staying up 24/7 (operator ask, 2026-09-12)

The board runs from the **scheduled task `FightCamp Ops Board`**, not from
the Startup folder any more. The old shortcut is renamed
`FightCamp Ops Board.lnk.disabled-superseded-by-scheduled-task` - rename it
back if you ever remove the task, or you will have no autostart at all.

Three triggers: at logon, at startup, and **every 5 minutes**. The repeating
one is what makes it self-healing - combined with `MultipleInstances:
IgnoreNew` it does nothing when the board is alive and relaunches it when it
is not, whatever killed it. `ExecutionTimeLimit` is zero so Windows never
stops it for running too long. Verified by killing the process and watching
the task restore it.

**Pre-logon: DONE (2026-09-12).** The checkout is pinned with
`attrib +P -U <root> /S /D` ("Always keep on this device", 0 cloud-only files
remaining) and the task runs `-LogonType S4U`, so it starts at boot without
anyone logging in. Verified under S4U: the page serves and all 8 agent rows
render, which also proves the frozen exe still finds a real Python for
`agent_comms.py` with no user profile loaded. **If the checkout ever leaves
OneDrive-pinned, revert to `-LogonType Interactive`** or the board will start
and read dehydrated files.

**The superseded gap, kept for the reasoning:** the task runs as the interactive user
(`LogonType: Interactive`), so the at-startup trigger does not fire until
somebody logs in. It is up whenever the machine is, but not on a rebooted
machine sitting at the login screen. Running pre-logon means `-LogonType
S4U`, and the reason that is NOT the default here is OneDrive: this repo
lives under it, an S4U task runs with no user profile and no OneDrive, and a
cloud-only placeholder file cannot hydrate - the board would start and read
nothing. Switch it only if the checkout is pinned to Always keep on this
device.

```powershell
Get-ScheduledTask -TaskName 'FightCamp Ops Board'   # state
Start-ScheduledTask -TaskName 'FightCamp Ops Board' # bring it up now
```

Two things differ when frozen and both are handled in `server.py`:
`sys.executable` is the exe rather than a Python, so `agent_comms.py` is run
through a real interpreter found on PATH (`_python_exe`), and `__file__`
points into a temp extraction dir, so the repo is resolved by marker rather
than by relative path (`_resolve_paths`). Without the first, the board renders
zero rows and blames nothing.

## The iPhone

The server binds `0.0.0.0`, so the phone only needs to be on the same Wi-Fi
as the PC. Open the `phone:` URL the server prints, in Safari.

Windows will block it until BOTH of these are true. Run in an **Administrator**
PowerShell:

```powershell
Set-NetConnectionProfile -InterfaceAlias Ethernet -NetworkCategory Private
New-NetFirewallRule -DisplayName "FightCamp Ops Board 8787" -Direction Inbound -Protocol TCP -LocalPort 8787 -Action Allow -Profile Private
```

The first is why it usually fails: on a `Public` network Windows drops inbound
LAN connections whatever the app does. Check with `Get-NetConnectionProfile`.

## The iPhone over 5G (off the LAN)

On mobile data the phone is not on your network, so `192.168.178.115` cannot
work whatever the firewall says. The board is reached through **Tailscale**, a
private mesh VPN: the PC and the phone join your own tailnet and talk over a
`100.x.y.z` address that is NOT on the public internet. No port forwarding, no
router change, nothing exposed.

This is deliberate. The board has no login and its roster switches are a POST
(`/api/roster`), so putting it on a public tunnel would let anyone with the URL
read your repo paths, task titles and agent activity and flip your switches.
Tailscale avoids that instead of papering over it.

Setup, once:

1. PC: `winget install --id Tailscale.Tailscale` (done), then sign in -
   `& 'C:\Program Files\Tailscale\tailscale.exe' up` prints a login URL.
2. Phone: install Tailscale from the App Store and sign in with the SAME
   account. Leave the VPN toggle on.
3. PC: `& 'C:\Program Files\Tailscale\tailscale.exe' ip -4` gives the
   tailnet address. The board is then `http://<that address>:8787/` from the
   phone, on 5G, anywhere.

If the phone connects but the page times out, it is the Windows Firewall on
the Tailscale adapter, not Tailscale: allow inbound 8787 as in the section
above. Keep the port rule scoped to Private, never Public.

## Self-test (the gate)

```bash
python Tools/opsboard/server.py --selftest
```

Parses every data source once, prints a row count per section, exits
non-zero if a required source is missing or unparseable. Roadmap load state
is reported but a missing roadmap does not fail the rest of the board.

## What is measured vs UNKNOWN

| Figure | Status |
| --- | --- |
| Open task / title / agent | Measured — `python Tools/agent_comms.py board` |
| Process up (qwen / codex / cursor) | Measured — Windows `tasklist` |
| Grok process | **Not detectable** — Grok runs in a browser |
| Elapsed / idle / median / longest duration | Measured — assignment stamps + git commit times |
| Commits / files / tests added | Measured — `git log` / `--numstat` |
| Suite total / fails | Measured — latest digest or done-mail line |
| Unread / unmerged / orphan digests | Measured — `board` + `triage` |
| Roadmap now / next / stages / sessions / assessment | From `AgentComms/roadmap.json` (assessment bars are **judgement**, attributed via `assessment.source`) |
| **Codex tokens** | Measured when a run log exists (`tokens used` line, else session `total_tokens`) |
| **Qwen / Grok / Cursor / Claude cost** | **UNKNOWN** — no per-task cost signal; never estimated |

Switches write `AgentComms/roster.json` as **intent** only. They do not
start or stop an agent. Claude reads the file at session start and skips
paused agents.
