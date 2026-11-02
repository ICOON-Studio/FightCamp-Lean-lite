# FightCamp Agent Comms

Conflict-free mailbox for **Claude**, **Codex**, **Cursor** and **John** — the
agents that can actually run this script. It supplements `HANDOFF.md`; claims, task
files and durable results stay there.

**Grok, Kalli and Maria take no mail (scoped 2026-09-07).** Assignment and the
mailbox are different things: all six are assignable, but a message is only
worth writing to an agent that reads one. Measured over 260 messages and 105
acks — claude 72 sent / 54 acked, codex 33 / 38, john 8 / 12; **maria
acknowledged none of her 16**, kalli 1 of 7, and **grok has never sent, received
or acknowledged anything**. The reason is already written in this repo: a Grok,
Kalli or Maria session runs off the GitHub API with **no Windows shell**, so it
cannot run `agent_comms.py` at all — the sends under their names are relays
Claude wrote. 25 messages sat unread forever. `--to`, `inbox` and `ack` now
refuse those three at the door.

Reach them the way they actually read:

| agent | reached through |
| --- | --- |
| grok | `## GROK START HERE` in `HANDOFF.md` + its task file (operator pastes it) |
| maria | root `TASKS.md` + `research/TASK_<id>.md` |
| kalli | root `TASKS.md` + `research/TASK_<id>.md` |

Sending **from** any of them stays open, because that is Claude relaying their
report into the mailbox and it is worth keeping.

```powershell
python Tools/agent_comms.py send --from codex --to claude --topic "C12 status" --body "Focused test and smoke are green."
python Tools/agent_comms.py inbox --agent claude
python Tools/agent_comms.py ack --agent claude --id <message-id>
python Tools/agent_comms.py tasks --write   # every OPEN task; also refreshes root TASKS.md
```

Use lowercase names. `--from` accepts any agent; `--to`, `inbox --agent` and
`ack --agent` accept only `codex`, `claude`, `cursor`, `qwen`, `john` or
`all`.
**Cursor joined 2026-09-07** and was a mailbox citizen from day one rather than
by measurement: it runs locally in this checkout with a real shell, which is the
only thing that ever separated the readers from the relays. **Qwen joined
2026-09-07** on that same test: the Qwen Windows app ships the Qwen Code CLI
(`%LOCALAPPDATA%/qwen-code/bin/qwen.cmd`, bundled node), so a Qwen session runs
in this checkout and can run this script, `check_scripts.py` and headless
Godot. Shell, not vendor, is the line. Qwen lost that seat 2026-09-08 when the
CLI would not authenticate and **got it back the same day** once it did: the
blocker was a masked key, a Token-Plan token in the wrong variable, and a repo
model pinned to a Coding Plan the account does not hold - never the shell. It
reads `QWEN.md` from the repo root. A send
creates one immutable JSON file; an acknowledgement creates a separate file,
so agents never edit the same message. Check the inbox once at task start,
acknowledge before acting, and send concise READY/BLOCKED/REVIEW updates.

Messages are instantly visible in this shared checkout. For a GitHub-only
recipient, commit and push **only the new message file**; the recipient fetches
before checking their inbox. Never put secrets or long transcripts in the
mailbox.

## Status board (Claude's tool, but anyone can run it)

```powershell
python Tools/agent_comms.py board                                   # one table: task, agent, status, gate, title
python Tools/agent_comms.py brief --agent codex                     # that agent's open task file(s) + unread inbox, copied to clipboard
python Tools/agent_comms.py block --task C12 --agent codex --why "..."  # record a blocker; survives /clear, shows on the board
python Tools/agent_comms.py unblock --task C12
python Tools/agent_comms.py scan                                    # pushed digests HANDOFF.md hasn't mentioned yet, + recent commits
python Tools/agent_comms.py done --task C12                         # runs check_scripts.py on the task's own '## Owned files' .gd list
python Tools/agent_comms.py sweep --dry-run                         # what the morning sweep would archive
python Tools/agent_comms.py sweep                                   # move finished blocks to HANDOFF_ARCHIVE.md
```

`sweep` is the chore `CLAUDE.md` has always asked for and nothing enforced: it
moves every finished `### ` block out of `HANDOFF.md`'s Active claims into
`HANDOFF_ARCHIVE.md`. A block is finished when its own header says so
(COMPLETE / LANDED / SUPERSEDED / CLOSED / RETIRED) **or** a `*_DIGEST.md` for
its task id is on disk — seven headers still said OPEN months after shipping.
The prose above the first `### ` is never touched, so token rulings, operator
decisions and the cycle narrative stay put. Run it when the day starts: it had
not run since 2026-09-04 and the slice every agent is told to read had grown to
2,324 lines (~38k tokens a session); after the first sweep it was 442.

`board` derives status from `HANDOFF.md`'s Active-claims headers (falling
back to "does a `*_DIGEST.md` exist") plus any open file in
`AgentComms/blockers/`. It is a read aid, not a new source of truth —
`HANDOFF.md` and the task files still decide what actually happened.
`done` will not mark a task COMPLETE by itself; it only proves the parse
gate passes and records that in `AgentComms/gates/<id>.json` so `board`
can show it.

## The working tree is SHARED (2026-09-07, learned the hard way)

Every local agent — Claude, Codex, Cursor — edits the **same checkout**. Git is
the only thing keeping them apart, and it does not protect work that is not yet
committed.

**Never run a bare `git stash`, `git reset --hard`, `git checkout .` or
`git clean` here.** On 2026-09-07 one session ran `git stash` followed by
`git pull --rebase` while another agent's finished-but-uncommitted stage sat in
the tree. Every file of that stage vanished from disk mid-session, including a
module rewrite and two test files.

- Scope destructive git to your own paths: `git stash push -- <your files>`.
- **Commit before you rebase**, not after. A commit is the only claim git honours.
- Before staging, read `git status -s`: another agent's WIP may already be
  staged, and `git add -A` will sweep it into your commit.

**Recovery.** Work destroyed this way is usually not lost — `git stash` keeps
it. Run `git stash list` and `git stash show --stat stash@{0}` before you
believe anything is gone; the 2026-09-07 loss was fully recovered with
`git stash pop`. Check `git reflog` for a moved HEAD.

## Writing a status header that the board can read

`board` and `TASKS.md` are generated from `HANDOFF.md`'s `### ` headers by
`STATUS_HEADER_RE`, which anchors on the status parenthesis. A header must end
with it:

```
### KALLI - K25: AFTER THE LAST FIGHT (COMPLETE 2026-09-07)
```

Put the commit hash in the `**Status:**` line, not after the parenthesis. A
header the regex cannot read used to drop the task from the board and from
`TASKS.md` in silence — the one file a shell-less agent reads. Since
2026-09-07 trailing punctuation is tolerated and anything still unreadable is
printed by `board` as a `WARNING`, so check that line before trusting the board.
