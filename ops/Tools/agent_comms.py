#!/usr/bin/env python3
"""Conflict-free FightCamp mailbox + status board; standard library only."""
from __future__ import annotations
import argparse, json, os, re, shutil, subprocess, sys, textwrap, threading, time
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from uuid import uuid4
sys.path.insert(0, str(Path(__file__).resolve().parent))

AGENTS = {"codex", "claude", "cursor", "qwen", "grok", "kalli", "maria", "john", "dola", "kimi", "all"}
# Who can OWN a task. "all" is an address, never an owner, so this is not
# AGENTS minus nothing - it is the ordered roster the board and TASKS.md
# iterate. cursor was missing from the two places below (2c80c26), which is
# why its seat printed nowhere.
# dola joined here 2026-09-22 (S47). She is green on the ops board and has
# held D4/D5/D6, but she was in neither tuple, so every Dola task printed
# owner "?" and `start` invented a phantom "?" agent holding eleven tasks.
# Same defect cursor had at 2c80c26. She takes no mail - she is driven by
# Tools/cici/cici.py - so she is ASSIGNABLE and is not a mailbox reader.
ASSIGNABLE = ("codex", "claude", "cursor", "qwen", "grok", "kalli", "maria", "john", "dola", "kimi")

# Who can be ADDRESSED. Assignment and the mailbox are different things: every
# agent in AGENTS can be given a TASK_<id>.md, but a message is only worth
# writing to an agent that reads one. Measured 2026-09-07 over 260 messages and
# 105 acks: claude 72 sent / 54 acked, codex 33 / 38, john 8 / 12 - all three
# read their mail. maria acked NONE of her 16, kalli 1 of 7, and grok has never
# sent, received or acked anything. The reason is in HANDOFF.md's own START HERE
# blocks: a grok, kalli or maria session runs off the GitHub API with NO WINDOWS
# SHELL, so it cannot run this script at all - the sends under their names are
# relays Claude wrote for them. 25 messages sat unread forever. Mail TO those
# three is refused at the door now; --from stays open so a relay still works.
# cursor joined 2026-09-07. It runs LOCALLY in this checkout with a real
# Windows shell, so unlike grok/kalli/maria it can run this script: it is a
# full mailbox citizen from day one, like codex.
# qwen was added 2026-09-07, demoted to a relay 2026-09-08, and RESTORED
# 2026-09-08 when the CLI finally authenticated - the condition this comment
# always named. Three stacked faults, none of them the repo's: the pasted key
# was a MASKED console value containing four literal asterisks; the real token
# is a ModelStudio TOKEN PLAN token, which OPENAI_API_KEY never reaches because
# settings.json binds each provider to its own envKey name
# (BAILIAN_TOKEN_PLAN_API_KEY); and .qwen/settings.json pinned qwen3-coder-plus,
# a CODING PLAN model on a separate subscription this account does not hold.
# Verified: qwen runs in this checkout, loads QWEN.md, reads files and reports
# its own rules back. Shell, not vendor, was always the line - qwen has one.
MAILBOX = {"codex", "claude", "cursor", "qwen", "john", "kimi", "all"}
NO_MAILBOX_HINT = ("%s does not take mail (measured: it never reads any). "
                   "Reach it through root TASKS.md and its research/TASK_<id>.md, "
                   "and for grok the '## GROK START HERE' block in HANDOFF.md.")
ROOT = Path(__file__).resolve().parents[1]
MESSAGES, ACKS = ROOT / "AgentComms" / "messages", ROOT / "AgentComms" / "acks"
BLOCKERS, GATES = ROOT / "AgentComms" / "blockers", ROOT / "AgentComms" / "gates"
RESEARCH = ROOT / "research"
GAME = ROOT.parent  # ops/ lives inside the Lean game repo; the Godot project is its root
HANDOFF = ROOT / "HANDOFF.md"

def agent(value: str) -> str:
    value = value.strip().lower()
    if value not in AGENTS: raise argparse.ArgumentTypeError("agent must be codex, claude, cursor, qwen, grok, kalli, maria, john, or all")
    return value

def addressee(value: str) -> str:
    """A --to, an --agent on inbox, or an --agent on ack. Sending FROM any agent
    stays open: maria's outbound art-ready reports are real and useful."""
    value = agent(value)
    if value not in MAILBOX:
        raise argparse.ArgumentTypeError(NO_MAILBOX_HINT % value)
    return value

def load(path: Path) -> dict:
    try: value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError): return {}
    return value if isinstance(value, dict) else {}

def now_stamp() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

def messages() -> list[Path]: return sorted(MESSAGES.glob("*.json"))

def acknowledged(message_id: str, recipient: str) -> bool:
    return any(load(path).get("message_id") == message_id and load(path).get("agent") == recipient for path in ACKS.glob("*.json"))

def stage(path: Path) -> str:
    """git add a file we just wrote.

    agent_comms.py wrote its output and never staged it, so eight separate
    agent reports existed only on disk and were invisible to every inbox that
    reads the pushed tree. Telling agents to `git add` it themselves was tried
    and kept being forgotten, which makes it a tool defect rather than eight
    mistakes. Best-effort: a failure here must never fail the send, but it is
    reported so it is never silent again.
    """
    try:
        result = subprocess.run(["git", "-C", str(ROOT), "add", "--", str(path)],
                                capture_output=True, text=True, timeout=20)
        if result.returncode == 0:
            return "staged=yes"
        return "staged=NO(git rc=%d)" % result.returncode
    except Exception as exc:
        return "staged=NO(%s)" % type(exc).__name__


def send(args: argparse.Namespace) -> int:
    MESSAGES.mkdir(parents=True, exist_ok=True)
    message_id = uuid4().hex[:12]
    timestamp = now_stamp()
    payload = {"id": message_id, "created_at": timestamp, "from": args.sender, "to": args.recipient, "topic": args.topic.strip(), "body": args.body.strip()}
    slug = re.sub(r"[^a-z0-9]+", "-", args.topic.lower()).strip("-")[:36] or "message"
    path = MESSAGES / f"{timestamp.replace(':', '').replace('-', '')}_{args.sender}_to_{args.recipient}_{slug}_{message_id}.json"
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"SENT id={message_id} path={path.relative_to(ROOT)} {stage(path)}")
    return 0

def inbox(args: argparse.Namespace) -> int:
    unread = [load(path) for path in messages() if load(path).get("to") in {args.agent, "all"} and not acknowledged(str(load(path).get("id", "")), args.agent)]
    for item in unread: print(f"[{item.get('id')}] {item.get('from')} -> {item.get('to')} | {item.get('topic')}\n{item.get('body')}\n")
    print(f"INBOX agent={args.agent} unread={len(unread)}")
    return 0

def ack(args: argparse.Namespace) -> int:
    if not any(load(path).get("id") == args.message_id for path in messages()): print("UNKNOWN MESSAGE id=" + args.message_id, file=sys.stderr); return 2
    ACKS.mkdir(parents=True, exist_ok=True)
    path = ACKS / f"{args.message_id}__{args.agent}.json"
    payload = {"message_id": args.message_id, "agent": args.agent, "acknowledged_at": now_stamp()}
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"ACK id={args.message_id} agent={args.agent} path={path.relative_to(ROOT)} {stage(path)}")
    return 0

# ---- task file + HANDOFF parsing (best-effort; a human still reads the files for detail) ----

# THE UNDERSCORE IS NOT COSMETIC (2026-09-22). Without it this pattern
# does not match TASK_ARENA_ART.md at all, parse_task falls through to
# path.stem, and the id becomes "TASK_ARENA_ART" - prefix included. That
# silently broke 14 task files, and they are the NEW long-running
# standing ones: ARENA_ART, CORNER_UI, GAME_FLOW, SOUND_RESEARCH,
# VFX_AND_PRESENTATION, SKILLS_IN_3D and the rest. Every id-keyed lookup
# missed them, `evidence_for` globbed for TASK_ARENA_ART_*.md which can
# never exist, so none of them could ever be closed by evidence.
# Checked before changing: NO HANDOFF or archive header and NO blocker
# record names either form, so nothing keys off the old prefixed id.
TASK_ID_RE = re.compile(r"TASK_([A-Za-z0-9_]+)\.md$")
TITLE_RE = re.compile(r"^#\s*TASK\s+\S+\s*[—-]\s*(.+?)\s*\(([^)]+)\)\s*$")
MODEL_RE = re.compile(r"^Model:.*$", re.MULTILINE)
# A path inside backticks, anywhere in an owned-files section. The closed
# extension list is the point: it is what stops `e.g`, `10-7`, `1.5 m` and a
# bare `_close_round()` being read as files. A trailing anchor is dropped
# because the pattern simply stops at the colon in `GameState.gd:727`.
BACKTICK_SPAN_RE = re.compile(r"`([^`]*)`")
OWNED_BACKTICK_RE = re.compile(
    r"(?:^|[\s(\[])([A-Za-z0-9_][A-Za-z0-9_./\\-]*\.(?:gd|md|json|tscn|py|png|jpg|jpeg|svg|txt|cfg|html|uid|import|tres|gdshader))\b")
# Lines that NAME a file in order to EXCLUDE it. Every one of these is real:
# R30's owned section lists what it deleted, R29's says "Codex owns
# GameState.gd - this stage does not touch it", and reading either as owned
# fails the gate on a file the task was forbidden to open.
NOT_OWNED_LINE_RE = re.compile(
    r"\b(?:delete|deleted|deletes|deleting|remove|removed|removes|"
    r"never written|not owned|was never|do not touch|does not touch|"
    r"never touch|must not touch|out of scope|read-only|read only|owns)\b",
    re.IGNORECASE)
# Every task file from R38 on declares ownership as a FENCED BLOCK of bare
# paths instead, each optionally annotated with the slice it owns:
#     Godot/scripts/GameState.gd    (:727 contract, :7519 GP event only)
# The bulleted-backtick form above matches none of those, so `done` found no
# owned files, printed "nothing to gate" and PASSED - vacuously, on the exact
# files it exists to check (found while closing R39, 2026-09-06). Fences only:
# the same section also carries prose naming files the task must NOT touch.
OWNED_FENCE_RE = re.compile(r"^```[^\n]*$(.*?)^```", re.MULTILINE | re.DOTALL)
OWNED_PATH_RE = re.compile(r"^\s*([A-Za-z0-9_.\\/-]+\.[A-Za-z0-9]+)\s*(?:\(.*\))?\s*$")
# A task file names files all over itself - constraints ("`UITokens.gd` only"),
# read-this-first pointers, do-not-touch lists, deletions. Only the owned-files
# section declares ownership, so the gate reads that section and nothing else.
# Three headings carry ownership across the existing task files (55 + 6 + 4
# bulleted scripts) and all three are honoured; the ten .gd bullets under any
# other heading are prose, which is the whole reason this is scoped.
# THE HEADING MAY CARRY A SUFFIX, and until 2026-09-12 it could not. This
# was anchored `\s*$`, so "## Owned files - these two only" did not match
# and the whole section was INVISIBLE to the gate. C95, Q65, U60 and U60B
# each declared their files correctly, in clean backticked bullets, and
# `triage` reported "gate cannot run" for every one of them.
#
# This project's own standing defect, in its own tooling: a gate demanding
# the world conform to it instead of reading what the world says. Read the
# heading as written; do not edit 166 task files into a shape a regex likes.
OWNED_SECTION_RE = re.compile(
    r"^## (?:Owned files|Files you own|Files)\b[^\n]*$(.*?)(?=^## |\Z)",
    re.MULTILINE | re.DOTALL | re.IGNORECASE,
)


BULLET_RE = re.compile(r"^\s*[-*+]\s")
SENTENCE_SPLIT_RE = re.compile(r"(?<=[.!?])\s+")


def owned_chunks(prose: str) -> list[str]:
    """The unit an exclusion binds to: a whole bullet (with its continuation
    lines) or a single sentence. Neither is the line - R30's deleted bullet
    wraps onto a line with no "Deleted" on it, and R29 puts "Codex owns
    GameState.gd" in the same line as a path it really does own."""
    chunks: list[str] = []
    for block in re.split(r"\n\s*\n", prose):
        if not block.strip():
            continue
        if any(BULLET_RE.match(line) for line in block.splitlines()):
            current: list[str] = []
            for line in block.splitlines():
                if BULLET_RE.match(line):
                    if current:
                        chunks.append("\n".join(current))
                    current = [line]
                elif current:
                    current.append(line)
                elif line.strip():
                    chunks.append(line)
            if current:
                chunks.append("\n".join(current))
        else:
            paragraph = " ".join(line.strip() for line in block.splitlines())
            chunks.extend(SENTENCE_SPLIT_RE.split(paragraph))
    return [chunk for chunk in chunks if chunk.strip()]


def owned_files(text: str) -> list[str]:
    """Every path declared under an OWNED FILES heading, in order - bulleted
    and backticked, or bare inside a fenced block with an optional trailing
    annotation."""
    found: list[str] = []

    def add(name: str) -> None:
        name = name.strip().replace("\\", "/")
        if name and name not in found:
            found.append(name)

    for section in OWNED_SECTION_RE.findall(text):
        fences = OWNED_FENCE_RE.findall(section)
        for fence in fences:
            for line in fence.splitlines():
                match = OWNED_PATH_RE.match(line)
                if match:
                    add(match.group(1))
        # Then the prose. Until 2026-09-08 this was one regex anchored on
        # "^- `path`", so a section written "- Edited: `a`, `b`" - or as a
        # sentence, "`GameState.gd` (append only), `Godot/tests/gym_hub_test.gd`
        # (new)" - parsed to NOTHING and `done` reported success on nothing.
        # Twelve task files declared ownership the gate could not see.
        prose = section
        for fence in fences:
            prose = prose.replace(fence, "\n")
        for chunk in owned_chunks(prose):
            if NOT_OWNED_LINE_RE.search(chunk):
                continue
            for span in BACKTICK_SPAN_RE.findall(chunk):
                for name in OWNED_BACKTICK_RE.findall(span):
                    add(name)
    return found


def declares_ownership(text: str) -> bool:
    """True when the task file HAS an owned-files section. A section that
    parses to nothing is a broken task file, not a task that owns nothing -
    the two must never be confused again."""
    return bool(OWNED_SECTION_RE.search(text))


def resolve_owned(name: str) -> str | None:
    """A bare basename is still a real file: task files sometimes write
    `GameState.gd` where the checker needs `Godot/scripts/GameState.gd`.
    Returns the repo-relative path, or None when nothing matches."""
    if (GAME / name).exists():
        return name
    if "/" not in name and "\\" not in name:
        for folder in ("scripts", "scripts/rules", "scripts/ui", "tests", "tools"):
            if (GAME / folder / name).exists():
                return f"{folder}/{name}"
    elif name.startswith("Godot/") and (GAME / name[len("Godot/"):]).exists():
        # briefs written for the old repo say "Godot/scripts/x.gd"; the Lean game is the repo root
        return name[len("Godot/"):]
    return None
# The trailing `[.,;:]*` is not cosmetic. This regex anchors on the closing
# parenthesis, so before 2026-09-07 a header written
#   "### KALLI - K25: ... (COMPLETE 2026-09-07, `44d5c5b`)."
# did not match: the task silently vanished from the board AND from TASKS.md,
# which is the one file a shell-less agent reads, and nothing said why.
# Punctuation after the parenthesis is allowed now, and unparsed_task_headers()
# reports anything still unreadable instead of dropping it in silence.
# 2026-09-10: the status is now ALSO read when it TRAILS the parenthesis.
# Eight finished tasks (Q34-Q38, C81, C82, U39) were invisible to the board
# and were reported OPEN because their authors wrote "... (`hash`). COMPLETE"
# rather than "... (COMPLETE, `hash`)". Telling eight agents to retype a
# header is the wrong fix for a shape this regex can simply accept.
# The status lands in group 2 (inside the parens) or group 3 (trailing);
# read it with _status_of() rather than group(2) directly.
# 2026-09-14: a header may name SEVERAL ids ("### KALLI - K35, K36, K37: ...")
# or say COLLECTED before the colon ("### CLAUDE - C109 COLLECTED: ..."). Both
# shapes are in the archive, and all four of those tasks read OPEN for a day
# after they were collected. Group 1 is the id LIST; statuses_in splits it.
STATUS_HEADER_RE = re.compile(
    r"^###.*?[-\u2014\u2013]\s*([A-Za-z0-9]+(?:\s*,\s*[A-Za-z0-9]+)*)"
    r"(?:\s*\([A-Za-z0-9]{1,3}\))?(?:\s+COLLECTED)?:"
    r"(?:.*?\((OPEN|COMPLETE)[^)]*\)[.,;:]*"
    r"|.*?\)?[.,;:]*\s*(OPEN|COMPLETE)\b[^()]*)"
    r"\s*$",
    re.MULTILINE)


def _status_of(match) -> str:
    """OPEN/COMPLETE from a STATUS_HEADER_RE match, in either spelling."""
    return (match.group(2) or match.group(3) or "").strip()
# A block header shaped like a task claim, status parenthesis or not.
TASKISH_HEADER_RE = re.compile(r"^###\s+[A-Za-z]+\s*[-—–]\s*([A-Za-z0-9]+):.*$", re.MULTILINE)
STATUS_LINE_RE = re.compile(r"\*\*Status:\s*(COMPLETE|IN PROGRESS|BLOCKED)")

## S241 (`start` took 5+ min): open_rows/triage/AGENTS each re-globbed research (1,500+ files) and re-read and
## re-parsed every TASK file once per call, and open_blocker re-loaded every blocker JSON once per task. One process
## sees one tree, so the listing, the parsed tasks and the blocker rows are computed once per process.
_RESEARCH_NAMES: tuple[str, list[str], list[str]] | None = None


def _research_listing() -> tuple[list[str], list[str]]:
    """(names, lower-cased names) of the top-level files in research, sorted by lower-case name; one scandir per process."""
    global _RESEARCH_NAMES
    if _RESEARCH_NAMES is None or _RESEARCH_NAMES[0] != str(RESEARCH):
        try:
            names = sorted((e.name for e in os.scandir(RESEARCH)), key=str.lower)
        except OSError:
            names = []
        _RESEARCH_NAMES = (str(RESEARCH), names, [n.lower() for n in names])
    return _RESEARCH_NAMES[1], _RESEARCH_NAMES[2]


def _research_prefixed(prefix: str, suffix: str) -> list[Path]:
    """RESEARCH.glob(prefix + "*" + suffix) (case-insensitive, as glob is on Windows), by bisect on the sorted listing."""
    import bisect
    names, lower = _research_listing()
    pre, suf = prefix.lower(), suffix.lower()
    out = []
    for i in range(bisect.bisect_left(lower, pre), len(lower)):
        if not lower[i].startswith(pre):
            break
        if lower[i].endswith(suf) and len(lower[i]) >= len(pre) + len(suf):
            out.append(RESEARCH / names[i])
    return out


_DIGEST_FILES: tuple[str, list[str], list[str]] | None = None


def _research_digests(key: str) -> list[Path]:
    """RESEARCH.glob("*" + key + "_DIGEST.md"): only the (few) *_DIGEST.md files are scanned, not every research file."""
    global _DIGEST_FILES
    names, lower = _research_listing()
    if _DIGEST_FILES is None or _DIGEST_FILES[0] != str(RESEARCH):
        idx = [i for i, n in enumerate(lower) if n.endswith("_digest.md")]
        _DIGEST_FILES = (str(RESEARCH), [names[i] for i in idx], [lower[i] for i in idx])
    want = key.lower() + "_digest.md"
    return [RESEARCH / n for n, ln in zip(_DIGEST_FILES[1], _DIGEST_FILES[2]) if ln.endswith(want)]


def task_files() -> list[Path]: return sorted(_research_prefixed("TASK_", ".md"))

_PARSED: dict[Path, dict] = {}

def parse_task(path: Path) -> dict:
    if path not in _PARSED:
        _PARSED[path] = _parse_task(path)
    return _PARSED[path]

def _parse_task(path: Path) -> dict:
    text = path.read_text(encoding="utf-8", errors="replace")
    id_match = TASK_ID_RE.search(path.name)
    task_id = id_match.group(1) if id_match else path.stem
    first_line = text.splitlines()[0] if text else ""
    title_match = TITLE_RE.match(first_line)
    title, owner = (title_match.group(1), title_match.group(2)) if title_match else (first_line.lstrip("# ").strip(), "?")
    if owner.strip().lower() not in AGENTS:
        # Older files name the owner inline: "TASK R31 - CLAUDE - THE RING".
        named = [name for name in ASSIGNABLE if re.search(r"\b" + name + r"\b", first_line, re.IGNORECASE)]
        if not named:
            # S6C names it on its own line instead: "**Owner:** Claude (lead)."
            # Without this the board printed owner "?" for a stage Claude ran,
            # and start's AGENTS block invented a phantom agent holding it.
            # "Agent:" joined "Owner:" here 2026-09-22 (S47). Eight task files
            # - C138, C139, C152, C153, K65, U112, U123 among them - head their
            # metadata "**Agent:** Codex" and were resolving to "?", so `start`
            # printed a phantom agent holding them. Read what the corpus
            # actually writes rather than making eight agents retype it, which
            # is the same call the comment above this function already made.
            owner_line = re.search(r"^\**(?:Owner|Agent):?\**:?\s*(.+)$", text, re.MULTILINE | re.IGNORECASE)
            if owner_line:
                named = [name for name in ASSIGNABLE
                         if re.search(r"\b" + name + r"\b", owner_line.group(1), re.IGNORECASE)]
        if not named:
            # LAST RESORT: the MODEL names the agent. Four files (C152, C153,
            # Q126, U123) declare ownership as prose - "You own C152." - with
            # no Owner/Agent heading at all, and were resolving to "?". The
            # model tier is fixed per agent by the operator's own settings, so
            # it identifies the owner without guessing. Added 2026-09-22 (S47)
            # after `start` printed a phantom "?" agent holding eight tasks.
            by_model = {
                "gpt-5.6-luna": "codex", "gpt-6-astra": "codex", "gpt-6.1-sol": "codex",
                "gpt-5.6-sol": "codex", "composer-2.5": "cursor",
                "qwen3-coder": "qwen",
            }
            for model_name, agent_name in by_model.items():
                if re.search(re.escape(model_name), text, re.IGNORECASE):
                    named = [agent_name]
                    break
        # A BLIND SPLIT HAS NO SINGLE OWNER, AND SAYING IT DOES IS WORSE
        # THAN "?". Three tasks - KNEE_OPINION, SKILLS_IN_3D and
        # SURFACE_INSTRUMENT - are deliberately asked of several agents, each
        # blind of the others, because the converged answer has beaten every
        # option on offer twice now. Reporting named[0] would park all three
        # on Codex and make it look busy while it is idle, which is the exact
        # question the board exists to answer. "multi" says what is true.
        if len(named) > 1:
            owner = "multi"
        else:
            owner = named[0] if named else "?"
    model_match = MODEL_RE.search(text)
    return {
        "id": task_id, "agent": owner.strip().lower(), "title": title.strip(),
        "model_line": model_match.group(0).strip() if model_match else "",
        "owned": owned_files(text), "declares_ownership": declares_ownership(text),
        "path": path, "text": text,
    }

def handoff_slice() -> str:
    if not HANDOFF.exists(): return ""
    text = HANDOFF.read_text(encoding="utf-8", errors="replace")
    match = re.search(r"^## Active claims.*?(?=^## Direction notes|\Z)", text, re.MULTILINE | re.DOTALL)
    return match.group(0) if match else text

def statuses_in(text: str) -> dict[str, str]:
    """A block's own "**Status:" line beats its header - seven headers still said
    OPEN months after the work shipped. Used for BOTH the live slice and the
    archive: before the sweep tool existed only the live path checked the body,
    so sweeping a stale-OPEN header used to resurrect it as an open task."""
    headers = list(STATUS_HEADER_RE.finditer(text))
    statuses = {}
    for index, header in enumerate(headers):
        header_status = _status_of(header)
        end = headers[index + 1].start() if index + 1 < len(headers) else len(text)
        line_match = STATUS_LINE_RE.search(text[header.end():end])
        for task_id in (part.strip() for part in header.group(1).split(",")):
            # Keyed UPPERCASE: the id comes off a hand-written header ("S6c")
            # and is looked up by the one TASK_<id>.md spells ("S6C"). A case
            # mismatch used to read as OPEN forever - S6c did, the day it shipped.
            statuses[task_id.upper()] = line_match.group(1) if line_match else header_status
    return statuses

def completed_index_slice() -> str:
    """The "## Completed stages: index" section of HANDOFF.md, which sits BELOW
    "## Direction notes" and so is outside handoff_slice() by construction.
    A stage that shipped TODAY has its COMPLETE block here and nowhere else -
    the morning sweep is what moves it to the archive. Without this section the
    board read S6c OPEN on the day it landed, which is the day it matters."""
    if not HANDOFF.exists(): return ""
    text = HANDOFF.read_text(encoding="utf-8", errors="replace")
    match = re.search(r"^## Completed stages: index.*?(?=^## |\Z)", text,
                      re.MULTILINE | re.DOTALL)
    return match.group(0) if match else ""

def handoff_statuses() -> dict[str, str]:
    # Completed index FIRST so a live claim in Active claims overrides it: a
    # task re-opened after a stage is the newer fact.
    statuses = statuses_in(completed_index_slice())
    statuses.update(statuses_in(handoff_slice()))
    return statuses

def unparsed_task_headers(text: str) -> list[str]:
    r"""Headers shaped like a task claim whose status parenthesis is unreadable.
    Surfaced rather than skipped: a silent drop is worse than a wrong status,
    because the task leaves the board and TASKS.md at once and nobody is told.

    Compared by START OFFSET, not by matched text: STATUS_HEADER_RE ends in
    `\s*$`, and `\s` eats the newline, so its match runs past the end of the
    line and never equals the one-line match this function scans with."""
    good = {match.start() for match in STATUS_HEADER_RE.finditer(text)}
    return [match.group(0).strip() for match in TASKISH_HEADER_RE.finditer(text)
            if match.start() not in good]

ARCHIVE = ROOT / "HANDOFF_ARCHIVE.md"

def archived_statuses() -> dict[str, str]:
    """Claude sweeps finished blocks out of HANDOFF.md every morning, so a
    task can be long done and still look OPEN here. One regex pass over the
    archive - never read by an agent, only by this tool. `sweep` writes it."""
    if not ARCHIVE.exists():
        return {}
    text = ARCHIVE.read_text(encoding="utf-8", errors="replace")
    return statuses_in(text)

def digest_exists(task_id: str) -> bool:
    return any(_research_digests(task_id))

_TRACKED: set[str] | None = None

def tracked_files() -> set[str]:
    """Every path git actually tracks, as repo-relative posix.

    WHY GIT AND NOT THE DISK. This checkout permanently carries untracked
    `.import`, `.uid`, scratch and delivery-staging files, and every agent
    writes into it. A deliverable sitting untracked on disk is scratch, not
    evidence that anything shipped - so the whole of `evidence_for` asks git,
    never `Path.exists()`. One `git ls-files` costs ~50 ms for 7,574 paths and
    is cached for the process."""
    global _TRACKED
    if _TRACKED is None:
        try:
            out = subprocess.run(["git", "ls-files"], cwd=ROOT,
                                 capture_output=True, text=True, check=True).stdout
            _TRACKED = {line.strip() for line in out.splitlines() if line.strip()}
        except Exception:
            # No git, a shallow or broken checkout: report NO evidence rather
            # than inventing it. An empty set makes every task fall through to
            # OPEN, which is the safe direction - it asks a human to look.
            _TRACKED = set()
    return _TRACKED

_IN_FLIGHT: set[str] | None = None

def in_flight_ids() -> set[str]:
    """Task ids named by a remote branch that is AHEAD of master and has NOT
    been collected.

    WHY THIS OVERRIDES EVIDENCE. A file named after a task is not proof the
    task finished - it can be a brief for the REST of the work. C134 is the
    case that found this: `C134_CONTINUE.md` exists and is tracked, so the
    evidence rule closed it, while `origin/codex/c134-bjj-presentation` sat
    41 commits ahead of master with the presentation unfinished. The honest
    signal is not the file's NAME - a blacklist of suffixes like CONTINUE or
    TODO is a fossil that drifts the moment somebody invents a new word - it
    is that the work is demonstrably still on a branch.

    A COLLECTED BRANCH DOES NOT COUNT. Eight branches here are ahead of
    master and carry a `collected/<name>` tag, meaning their content was
    audited onto master and only the branch was left undeleted. Treating
    those as in flight would call finished work open, which is the same
    defect pointing the other way. `collected_tips` is the same map `triage`
    uses, so the two reports cannot disagree."""
    global _IN_FLIGHT
    if _IN_FLIGHT is None:
        found: set[str] = set()
        try:
            tips = collected_tips()
            for branch, (tip, _when, ahead, _behind) in branch_table().items():
                if branch in ("origin/main", "origin/HEAD") or tip in tips:
                    continue
                if not ahead:
                    continue
                # "codex/c134-bjj-presentation" -> C134
                for chunk in re.split(r"[/_-]", branch):
                    if re.fullmatch(r"[a-z]{1,2}\d{1,3}", chunk):
                        found.add(chunk.upper())
        except Exception:
            # No git, or a shallow clone where master..branch is meaningless.
            # Report nothing in flight: evidence then stands on its own, which
            # is the behaviour this function was added to refine, not replace.
            found = set()
        _IN_FLIGHT = found
    return _IN_FLIGHT

def evidence_for(task_id: str) -> str:
    """WHAT ON DISK SAYS THIS TASK FINISHED - or "" if nothing does.

    THE DEFECT THIS CLOSES (operator ask, 2026-09-22). Task status was derived
    from a HAND-WRITTEN `### AGENT - ID: ... (COMPLETE)` header in HANDOFF.md,
    so a task whose work shipped months ago still read OPEN if nobody typed
    the line. Measured here before the change: **104 task files read OPEN, and
    77 of them had a landed deliverable in git.** The board therefore could
    not answer "who is idle", which is the one question it exists for.

    So status falls back to EVIDENCE. Three kinds, strongest first, and the
    reason is returned rather than swallowed so a reader can audit every
    close. It deliberately does NOT look at commit messages: an id in a commit
    subject says somebody mentioned the task, not that it delivered.

    IT MUST BE ABLE TO SAY "". A gate that finds evidence for everything is
    the same as no gate - see `Tools/test_agent_comms_evidence.py`, which
    holds it to a fixture where the honest answer is nothing."""
    if task_id.upper() in in_flight_ids():
        # Still on an uncollected branch. Whatever file is named after it is
        # not a finished deliverable - see in_flight_ids.
        return ""
    tracked = tracked_files()

    # WHICH NAMES COUNT AS "NAMED AFTER THIS TASK". The id itself, and - when
    # the id LEADS with an agent code - that code on its own. TASK_C161_
    # OCTAGON_DECK has id C161_OCTAGON_DECK, and Codex wrote its digest as
    # C161_DIGEST.md, because the code is what an agent actually types. Only
    # a real code is stripped (one or two letters then digits, the same shape
    # in_flight_ids reads off a branch name), so ARENA_ART never degrades to
    # "ARENA" and start matching another task's files.
    keys = [task_id]
    head = task_id.split("_")[0]
    if head != task_id and re.fullmatch(r"[A-Za-z]{1,2}\d{1,3}", head):
        keys.append(head)

    # 1. A digest: the strongest, because writing one is the last step of the
    #    task and it is named after the task and nothing else.
    for key in keys:
        for path in sorted(_research_digests(key)):
            if path.relative_to(ROOT).as_posix() in tracked:
                return f"digest {path.name}"

    # 2. A deliverable named after the task. `<ID>_*.md` cannot match the task
    #    file itself, which is `TASK_<ID>.md`, and the underscore anchors the
    #    id so C13 never matches a C134 file.
    for key in keys:
        for path in sorted(_research_prefixed(f"{key}_", ".md")):
            if path.relative_to(ROOT).as_posix() in tracked:
                return f"deliverable {path.name}"

    # 3. Every file the task DECLARES it owns is tracked. Weakest of the
    #    three, and only counted when the task named them itself: a task with
    #    no owned-files section gets nothing here, exactly as `done --task`
    #    refuses to gate one.
    task_path = RESEARCH / f"TASK_{task_id}.md"
    if task_path.exists():
        owned = owned_files(task_path.read_text(encoding="utf-8", errors="replace"))
        if owned:
            resolved = [resolve_owned(name) for name in owned]
            if all(r and r in tracked for r in resolved):
                return f"{len(owned)} owned file(s) landed"
    return ""

def evidence_closed() -> list[tuple[str, str, str]]:
    """(id, agent, reason) for every task closed by evidence rather than by a
    hand-written header. This is the audit trail for the fallback above: if it
    ever closes something that is genuinely open, it shows up here.

    IT ASKS `status_of` RATHER THAN RE-DERIVING ITS PRECEDENCE, and that is
    not a style preference. The first version of this function re-implemented
    the blocker / HANDOFF / archive / evidence order by hand, read the LAZY
    `_ARCHIVED` global while it was still None, skipped the archive check
    entirely and reported 655 tasks instead of 77 - every long-finished task
    in the corpus. `COMPLETE?` is the status `status_of` returns for exactly
    this case, so ask it and filter."""
    statuses = handoff_statuses()
    out = []
    for task in (parse_task(path) for path in task_files()):
        if status_of(task["id"], statuses) != "COMPLETE?":
            continue
        out.append((task["id"], task["agent"], evidence_for(task["id"])))
    return out

def blocker_files() -> list[Path]: return sorted(BLOCKERS.glob("*.json")) if BLOCKERS.exists() else []

_BLOCKER_ROWS: list[dict] | None = None

def open_blocker(task_id: str) -> dict | None:
    global _BLOCKER_ROWS
    if _BLOCKER_ROWS is None:
        _BLOCKER_ROWS = [load(p) for p in blocker_files()]
    candidates = [b for b in _BLOCKER_ROWS if b.get("task") == task_id and not b.get("resolved_at")]
    return candidates[-1] if candidates else None

def gate_result(task_id: str) -> dict | None:
    path = GATES / f"{task_id}.json"
    return load(path) if path.exists() else None

def clipboard_copy(text: str) -> bool:
    try:
        subprocess.run(["clip"], input=text.encode("utf-16le"), check=True)
        return True
    except Exception:
        return False

_ARCHIVED: dict[str, str] | None = None

def status_of(task_id: str, statuses: dict[str, str]) -> str:
    global _ARCHIVED
    if open_blocker(task_id): return "BLOCKED"
    key = task_id.upper()
    if key in statuses: return statuses[key]
    if _ARCHIVED is None: _ARCHIVED = archived_statuses()
    if key in _ARCHIVED: return _ARCHIVED[key]
    # NOBODY WROTE A HEADER FOR THIS ONE. Ask the tree instead of
    # calling it open by default - see evidence_for.
    return "COMPLETE?" if evidence_for(task_id) else "OPEN"

def brief(args: argparse.Namespace) -> int:
    statuses = handoff_statuses()
    tasks = [parse_task(p) for p in task_files()]
    mine = [t for t in tasks if t["agent"] == args.agent and status_of(t["id"], statuses) not in {"COMPLETE"}]
    if not mine:
        print(f"No open task file for {args.agent}.")
        return 0
    parts = []
    for t in mine:
        status = status_of(t["id"], statuses)
        blocker = open_blocker(t["id"])
        parts.append(f"=== TASK {t['id']} ({status}) — {t['title']} ===")
        if blocker:
            parts.append(f"[OPEN BLOCKER {blocker.get('created_at')}] {blocker.get('why')}")
        parts.append(t["text"].rstrip())
    unread = [load(p) for p in messages() if load(p).get("to") in {args.agent, "all"} and not acknowledged(str(load(p).get("id", "")), args.agent)]
    if unread:
        parts.append("=== INBOX ===")
        for item in unread:
            parts.append(f"[{item.get('id')}] {item.get('from')} -> {item.get('to')} | {item.get('topic')}\n{item.get('body')}")
    text = "\n\n".join(parts)
    print(text)
    if not args.no_clip and clipboard_copy(text):
        print("\n(copied to clipboard)", file=sys.stderr)
    return 0

def board(args: argparse.Namespace) -> int:
    statuses = handoff_statuses()
    rows = []
    for t in (parse_task(p) for p in task_files()):
        status = status_of(t["id"], statuses)
        gate = gate_result(t["id"])
        gate_flag = "" if not gate else ("gate:pass" if gate.get("passed") else "gate:fail")
        rows.append((t["id"], t["agent"], status, gate_flag, t["title"]))
    width_id = max([len("TASK")] + [len(r[0]) for r in rows])
    width_agent = max([len("AGENT")] + [len(r[1]) for r in rows])
    width_status = max([len("STATUS")] + [len(r[2]) for r in rows])
    print(f"{'TASK'.ljust(width_id)}  {'AGENT'.ljust(width_agent)}  {'STATUS'.ljust(width_status)}  GATE       TITLE")
    for task_id, owner, status, gate_flag, title in rows:
        print(f"{task_id.ljust(width_id)}  {owner.ljust(width_agent)}  {status.ljust(width_status)}  {gate_flag.ljust(10)} {title}")
    unread_counts: dict[str, int] = {}
    stranded: dict[str, int] = {}
    for path in messages():
        item = load(path)
        recipient = item.get("to")
        if not recipient or acknowledged(str(item.get("id", "")), recipient):
            continue
        # Mail addressed to an agent that cannot run this script will never be
        # acknowledged, so counting it as "unread" put a number on the board
        # that could not go down. Reported separately and named for what it is:
        # those agents are reached through TASKS.md and their own task file.
        bucket = unread_counts if recipient in MAILBOX else stranded
        bucket[recipient] = bucket.get(recipient, 0) + 1
    if unread_counts:
        print("\nUNREAD: " + ", ".join(f"{name}={count}" for name, count in sorted(unread_counts.items())))
    if stranded:
        print("STRANDED (recipient has no shell; reach them via TASKS.md + their task file): "
              + ", ".join(f"{name}={count}" for name, count in sorted(stranded.items())))
    for header in unparsed_task_headers(handoff_slice()):
        print(f"WARNING unreadable status header - this task is MISSING from the board: {header}")
    return 0

TASKS_FILE = ROOT / "TASKS.md"

def open_rows() -> list[dict]:
    """Every task that is not finished. THIS - not any chat client's session
    list - is what "tasks" means in this repository."""
    statuses = handoff_statuses()
    rows = []
    for task in (parse_task(path) for path in task_files()):
        status = status_of(task["id"], statuses)
        if status in {"COMPLETE", "COMPLETE?"}:
            continue
        blocker = open_blocker(task["id"])
        rows.append({
            "id": task["id"], "agent": task["agent"], "status": status, "title": task["title"],
            "model": task["model_line"].split(". ")[0].rstrip(".") + "." if task["model_line"] else "",
            "path": task["path"].relative_to(ROOT).as_posix(),
            "why": str(blocker.get("why", "")) if blocker else "",
        })
    return rows

def tasks_text() -> str:
    rows = open_rows()
    lines = ["# Open tasks - FightCamp", "",
             "Generated by `python Tools/agent_comms.py tasks --write` from",
             "`research/TASK_*.md` plus the `## Active claims` slice of `HANDOFF.md`.",
             "",
             "**In this repository a TASK is a `research/TASK_<id>.md` file and nothing",
             "else** - never a chat, a session, or an entry in an assistant's own task list.",
             "If you were asked to check for tasks, the answer is below, or run",
             "`python Tools/agent_comms.py tasks`.", ""]
    if not rows:
        lines += ["**Nothing is open.**", ""]
    for row in rows:
        lines.append("## " + row["id"] + " - " + row["title"])
        lines.append("")
        lines.append("- Owner: **" + row["agent"] + "**")
        lines.append("- Status: **" + row["status"] + "**")
        lines.append("- File: `" + row["path"] + "`")
        if row["model"]:
            lines.append("- " + row["model"])
        if row["why"]:
            lines.append("- BLOCKED: " + row["why"])
        lines.append("")
    idle = sorted(set(ASSIGNABLE) - {row["agent"] for row in rows})
    if idle:
        lines += ["Nothing open for: " + ", ".join(idle) + ".", ""]
    lines += ["Full brief for one agent (prints the whole task file):", "",
              "```", "python Tools/agent_comms.py brief --agent <%s>" % "|".join(ASSIGNABLE), "```", ""]
    return "\n".join(lines)

def evidence_report(_args: argparse.Namespace) -> int:
    """Every task the EVIDENCE fallback closed, and the file that closed it.

    Read this when the board's idle count looks wrong. Each row is a task
    nobody wrote a HANDOFF header for, whose deliverable is nonetheless in
    git; if a row here is a task that is genuinely still open, the deliverable
    named beside it is the thing to look at."""
    rows = evidence_closed()
    print("CLOSED BY EVIDENCE, NOT BY A HANDOFF HEADER - %d task(s)" % len(rows))
    print("Status came from the tree because no header exists. Audit any row that looks wrong.")
    by_agent: dict[str, list[tuple[str, str, str]]] = {}
    for row in rows:
        by_agent.setdefault(row[1], []).append(row)
    for agent in sorted(by_agent):
        print("\n%s  (%d)" % (agent.upper(), len(by_agent[agent])))
        for task_id, _agent, reason in sorted(by_agent[agent]):
            print("    %-22s %s" % (task_id, reason))
    if not rows:
        print("\nNothing. Every task's status is hand-written.")
    return 0

def tasks(args: argparse.Namespace) -> int:
    rows = open_rows()
    if args.agent and args.agent != "all":
        rows = [row for row in rows if row["agent"] == args.agent]
    print("OPEN TASKS - a task here is a research/TASK_<id>.md file, never a chat session.")
    if not rows:
        print("NOTHING OPEN" + (" for " + args.agent if args.agent and args.agent != "all" else ""))
    for row in rows:
        print("\n" + row["id"] + "  " + row["agent"].upper() + "  " + row["status"] + "  " + row["title"])
        print("    file: " + row["path"])
        if row["model"]:
            print("    " + row["model"])
        if row["why"]:
            print("    BLOCKED: " + row["why"])
    closed = evidence_closed()
    if closed:
        print("\n%d task(s) are not listed above because a deliverable for them is\n    in git, though nobody wrote a HANDOFF header. List them with their\n    evidence: python Tools/agent_comms.py evidence" % len(closed))
    print("\nFull brief: python Tools/agent_comms.py brief --agent <name>")
    if args.write:
        TASKS_FILE.write_text(tasks_text(), encoding="utf-8")
        print("WROTE " + TASKS_FILE.relative_to(ROOT).as_posix())
    return 0

def block(args: argparse.Namespace) -> int:
    BLOCKERS.mkdir(parents=True, exist_ok=True)
    blocker_id = uuid4().hex[:12]
    created_at = now_stamp()
    payload = {"id": blocker_id, "created_at": created_at, "task": args.task.strip(), "agent": args.agent, "why": args.why.strip(), "resolved_at": None}
    path = BLOCKERS / f"{created_at.replace(':', '').replace('-', '')}_{args.task}_{blocker_id}.json"
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"BLOCKED task={args.task} id={blocker_id} path={path.relative_to(ROOT)}")
    return 0

def unblock(args: argparse.Namespace) -> int:
    open_ones = [p for p in blocker_files() if load(p).get("task") == args.task and not load(p).get("resolved_at")]
    if not open_ones:
        print(f"No open blocker on record for {args.task}", file=sys.stderr)
        return 2
    for path in open_ones:
        payload = load(path)
        payload["resolved_at"] = now_stamp()
        path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"UNBLOCKED task={args.task} cleared={len(open_ones)}")
    return 0

def scan(args: argparse.Namespace) -> int:
    slice_text = handoff_slice()
    unreported = [t["id"] for t in (parse_task(p) for p in task_files()) if digest_exists(t["id"]) and t["id"] not in slice_text]
    print("Digests not yet mentioned in HANDOFF Active claims: " + (", ".join(unreported) if unreported else "none"))
    open_blockers = [load(p) for p in blocker_files() if not load(p).get("resolved_at")]
    if open_blockers:
        print("\nOpen blockers:")
        for b in open_blockers: print(f"  [{b.get('task')}] {b.get('why')} ({b.get('created_at')})")
    try:
        log = subprocess.run(["git", "-C", str(ROOT), "log", "--oneline", "-10"], capture_output=True, text=True, check=True).stdout
        print("\nRecent commits:\n" + log.rstrip())
    except Exception as exc:
        print(f"(git log unavailable: {exc})", file=sys.stderr)
    return 0

# ---- the morning sweep: finished blocks leave the live file, nothing is lost ----
# CLAUDE.md has always said Claude sweeps completed blocks into HANDOFF_ARCHIVE.md
# at each day's start. Nothing enforced it, so it stopped on 2026-09-04 and the
# "## Active claims" slice every agent is told to read grew to 2,324 lines - 84%
# of the whole file, about 38k tokens a session. This is that chore, as a command.

FINISHED_WORDS = ("COMPLETE", "LANDED", "SUPERSEDED", "CLOSED", "RETIRED")
HEADER_ID_RE = re.compile(r"\b([A-Z]{1,2}\d{1,3})\b")

def active_bounds(lines: list[str]) -> tuple[int, int]:
    start = next((i for i, l in enumerate(lines) if l.startswith("## Active claims")), -1)
    if start < 0:
        return (-1, -1)
    end = next((i for i, l in enumerate(lines[start + 1:], start + 1) if l.startswith("## ")), len(lines))
    return (start, end)

def h3_blocks(lines: list[str], start: int, end: int) -> list[tuple[int, int, str]]:
    """Every '### ' block inside Active claims, as (first_line, stop_line, header).
    The prose above the first '### ' is never touched: the token rulings, the
    operator decisions and the cycle narrative all live there."""
    heads = [i for i in range(start, end) if lines[i].startswith("### ")]
    return [(h, (heads[n + 1] if n + 1 < len(heads) else end), lines[h]) for n, h in enumerate(heads)]

def finished_because(header: str) -> str:
    """Why this block is done: a word in its own header, or a pushed digest that
    proves the header is simply stale (seven blocks still said OPEN months after
    they shipped). Anything else stays put."""
    upper = header.upper()
    for word in FINISHED_WORDS:
        if word in upper:
            return word.lower()
    for task_id in HEADER_ID_RE.findall(header):
        if digest_exists(task_id):
            return "digest " + task_id
    return ""

def sweep(args: argparse.Namespace) -> int:
    if not HANDOFF.exists():
        print("no HANDOFF.md", file=sys.stderr)
        return 2
    text = HANDOFF.read_text(encoding="utf-8", errors="replace")
    newline = "\r\n" if "\r\n" in text else "\n"
    lines = [l[:-1] if l.endswith("\r") else l for l in text.split("\n")]
    start, end = active_bounds(lines)
    if start < 0:
        print("no '## Active claims' section", file=sys.stderr)
        return 2

    moving, keeping = [], []
    for first, stop, header in h3_blocks(lines, start, end):
        reason = finished_because(header)
        (moving if reason else keeping).append((first, stop, header, reason))
    if not moving:
        print("SWEEP nothing finished in Active claims")
        return 0

    print("SWEEP %d finished block(s), %d staying:" % (len(moving), len(keeping)))
    for _, _, header, reason in moving:
        print("  archive  %-88s <- %s" % (header[:88], reason))
    for _, _, header, _ in keeping:
        print("  keep     %s" % header[:88])
    if args.dry_run:
        print("DRY RUN - nothing written")
        return 0

    moved, drop = [], set()
    for first, stop, header, _ in moving:
        moved.append("\n".join(lines[first:stop]).rstrip())
        drop.update(range(first, stop))
    kept = [l for i, l in enumerate(lines) if i not in drop]

    body = "## ===== Swept out of HANDOFF.md on %s =====\n\n%s\n" % (now_stamp()[:10], "\n\n".join(moved))
    archive = ARCHIVE.read_text(encoding="utf-8", errors="replace") if ARCHIVE.exists() else "# FightCamp handoff archive\n"
    marker = "API-side agents to read whole. Newest first, same format."
    if marker in archive:
        head, tail = archive.split(marker, 1)
        archive = head + marker + "\n\n" + body + tail
    else:
        archive = archive.rstrip() + "\n\n" + body
    ARCHIVE.write_text(newline.join(archive.split("\n")), encoding="utf-8")
    HANDOFF.write_text(newline.join(kept), encoding="utf-8")

    a_start, a_end = active_bounds(kept)
    slice_text = "\n".join(kept[a_start:a_end])
    print("WROTE %s (+%d blocks) and %s" % (ARCHIVE.name, len(moving), HANDOFF.name))
    print("Active claims slice is now %d lines / %d bytes" % (a_end - a_start, len(slice_text)))
    return 0

def done(args: argparse.Namespace) -> int:
    matches = [t for t in (parse_task(p) for p in task_files()) if t["id"] == args.task]
    if not matches:
        print(f"No task file for {args.task}", file=sys.stderr)
        return 2
    task = matches[0]
    if not task["declares_ownership"]:
        # The vacuous pass, closed. A file with no owned-files section fell
        # through to "nothing to gate" and returned 0 - on 2026-09-08 that was
        # 89 of 166 task files, more than half the corpus, every one of them
        # reporting a gate it had never run. Refuse instead of inventing a pass.
        print(f"GATE FAIL task={args.task}: {task['path'].relative_to(ROOT).as_posix()} "
              f"has no '## Owned files' section, so there is nothing to gate and a "
              f"pass would be vacuous. Add the section, then re-run.", file=sys.stderr)
        return 1
    if not task["owned"]:
        print(f"GATE FAIL task={args.task}: '## Owned files' section parses to no "
              f"paths - fix {task['path']} (or the parser), do not call this COMPLETE",
              file=sys.stderr)
        return 1
    declared = [f for f in task["owned"] if f.endswith(".gd")]
    owned_scripts, missing = [], []
    for name in declared:
        resolved = resolve_owned(name)
        (owned_scripts if resolved else missing).append(resolved or name)
    if missing:
        print(f"GATE FAIL task={args.task}: owned file(s) not found: {', '.join(missing)}", file=sys.stderr)
        return 1
    if not owned_scripts:
        # An art or research task owns no scripts at all. There is nothing to
        # parse, and that is a pass - not a failure to be worked around. Clear
        # any record left by an earlier run so the board stops reporting a gate
        # that no longer exists.
        stale = GATES / f"{args.task}.json"
        if stale.exists():
            stale.unlink()
            print(f"(cleared stale gate record for {args.task})")
        owns = ", ".join(matches[0]["owned"]) or "nothing"
        print(f"No owned .gd files for {args.task} (owns: {owns}); nothing to gate.")
        return 0
    checker = GAME / "tools" / "check_scripts.py"
    if not checker.exists():
        print(f"No parse checker at {checker} - run the parse gate from the Lean CLAUDE.md for: {' '.join(owned_scripts)}")
        return 2
    result = subprocess.run([sys.executable, str(checker), *owned_scripts], cwd=GAME, capture_output=True, text=True)
    passed = result.returncode == 0
    GATES.mkdir(parents=True, exist_ok=True)
    payload = {"task": args.task, "checked_at": now_stamp(), "passed": passed, "files": owned_scripts, "output": (result.stdout + result.stderr)[-4000:]}
    gate_path = GATES / f"{args.task}.json"
    gate_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    gate_staged = stage(gate_path)
    print(result.stdout, end="")
    print(result.stderr, end="", file=sys.stderr)
    print(f"GATE {'PASS' if passed else 'FAIL'} task={args.task} {gate_staged}")
    return 0 if passed else 1

# ---- triage: the work that landed and never reached the board ----
# 2026-09-08, from two misses in one session. U10 shipped and its report was
# written to the agent's OWN BRANCH, so `inbox` never saw it - the work was
# found only because the branch turned up in a fetch. C45 landed on master with
# no HANDOFF block at all. Neither is a missing feature; both are "finished work
# nobody told the board about", and nothing was looking for them.
#
# This command looks, and it REPORTS ONLY - it never writes a file. Assignment
# (who, which model, what effort) and HANDOFF prose stay judgement calls that a
# human or Claude makes, deliberately (operator decision, 2026-09-08). It also
# makes no model call: every check here is a git query or a regex, so running it
# at the start of every session costs nothing against the credit budget.

def git(*args: str) -> str:
    """git, or an empty string. A triage report must never be the thing that
    fails the session, so an offline machine degrades to fewer findings."""
    try:
        return subprocess.run(["git", "-C", str(ROOT), *args], capture_output=True, text=True, check=True).stdout
    except Exception:
        return ""


GH_TIMEOUT = 10  # S241: a hung gh (network, auth prompt) must never hold the session start


def _arena_prs() -> list[str]:
    prs: list[str] = []
    gh = shutil.which("gh")
    if gh:
        try:
            run = subprocess.run([gh, "pr", "list", "--state", "open", "--json", "number,title,headRefName,url"],
                                 capture_output=True, text=True, timeout=GH_TIMEOUT)
            for pr in json.loads(run.stdout or "[]"):
                if str(pr.get("headRefName", "")).startswith("arena/"):
                    prs.append(f"#{pr['number']} {pr['headRefName']}: {pr['title']}")
        except (OSError, ValueError, subprocess.TimeoutExpired):
            prs.append("(gh pr list failed - check by hand)")
    else:
        prs.append("(gh not on PATH - PRs not listed)")
    return prs


def _arena_status() -> None:
    """Operator ruling 2026-10-03: Arena (arena.ai Agent Mode) works only on arena/* branches and opens its own PR;
    Claude reviews and merges. Show what is open so a landed branch is never missed."""
    branches = [b.strip() for b in git("branch", "-r", "--list", "origin/arena/*").splitlines() if b.strip()]
    prs = _await("gh")
    print(f"  ARENA   branches {len(branches)}, open PRs {len([p for p in prs if p.startswith('#')])}"
          " (review + merge them yourself; never Arena's Merge PR button - CLAUDE.md s8)")
    ## S201 (operator: "every session starts at ~96k tokens"): the 45 branch names cost ~2k chars a session and nobody
    ## read them; the open PRs are what get collected. Names: `git branch -r --list "origin/arena/*"`.
    for line in prs:
        print("          " + line)


_BRANCH_TABLE: dict[str, tuple[str, str, int, int]] | None = None


def branch_table() -> dict[str, tuple[str, str, int, int]]:
    """origin ref (short name) -> (tip sha, committer date YYYY-MM-DD, commits ahead of master, commits behind), ONE
    `git for-each-ref`. S241: triage and in_flight_ids ran `log -1`, `rev-parse`, `merge-base`, `log master..b` and
    `rev-list --count` per remote branch (~500-850 refs x 2-5 git processes = the 115 s + most of the 90 s `start` spent)."""
    global _BRANCH_TABLE
    if _BRANCH_TABLE is None:
        rows: dict[str, tuple[str, str, int, int]] = {}
        out = git("for-each-ref", "--format=%(objectname) %(committerdate:short) %(ahead-behind:master) %(refname:short)",
                  "refs/remotes/origin")
        for line in out.splitlines():
            parts = line.split(None, 4)
            if len(parts) == 5 and parts[2].isdigit() and parts[3].isdigit():
                rows[parts[4].strip()] = (parts[0], parts[1], int(parts[2]), int(parts[3]))
        _BRANCH_TABLE = rows
    return _BRANCH_TABLE


def master_commit_count() -> int:
    try:
        return int(git("rev-list", "--count", "main").strip() or 0)
    except ValueError:
        return 0


def branch_facts(branch: str, master_total: int) -> tuple[str, str, int | None]:
    """(last commit date, tip sha, commits not on master - None when branch and master share no history).
    No merge-base <=> every commit of master is 'behind' the branch, so one `for-each-ref` answers all three."""
    row = branch_table().get(branch)
    if row and master_total:
        tip, when, ahead, behind = row
        return when or "?", tip, (ahead if behind != master_total else None)
    when = git("log", "-1", "--format=%cs", branch).strip() or "?"
    tip = git("rev-parse", branch).strip()
    if git("merge-base", "main", branch).strip():
        return when, tip, len([l for l in git("log", "--oneline", "master.." + branch).splitlines() if l.strip()])
    return when, tip, None


def branch_only_messages_bulk(branches: list[str]) -> dict[str, list[str]]:
    """branch_only_messages for many branches through ONE `git cat-file --batch` (500 `ls-tree` processes before)."""
    if not branches:
        return {}
    local = {path.name for path in messages()}
    out: dict[str, list[str]] = {}
    try:
        feed = "".join("%s:AgentComms/messages%s" % (b, chr(10)) for b in branches).encode("utf-8")
        data = subprocess.run(["git", "-C", str(ROOT), "cat-file", "--batch"], input=feed, capture_output=True, check=True).stdout
        pos = 0
        for branch in branches:
            end = data.index(bytes([10]), pos)
            header = data[pos:end].decode("utf-8", "replace")
            pos = end + 1
            if header.endswith(" missing"):
                out[branch] = []
                continue
            _sha, kind, size = header.split()
            body, pos = data[pos:pos + int(size)], pos + int(size) + 1
            if kind != "tree":
                out[branch] = branch_only_messages(branch)
                continue
            names, nested, i = [], False, 0
            while i < len(body):
                sp = body.index(b" ", i)
                zero = body.index(bytes([0]), sp)
                mode, name = body[i:sp], body[sp + 1:zero].decode("utf-8", "replace")
                i = zero + 21  # 20-byte object id
                if mode == b"40000":
                    nested = True
                elif name.endswith(".json") and name not in local:
                    names.append(name)
            out[branch] = branch_only_messages(branch) if nested else names
    except Exception:
        return {b: branch_only_messages(b) for b in branches}
    return out


def unmerged_branches() -> list[str]:
    out = git("branch", "-r", "--no-merged", "main")
    names = []
    for line in out.splitlines():
        name = line.strip()
        if not name or "->" in name or name.endswith("/master"):
            continue
        names.append(name)
    return names


def branch_only_messages(branch: str) -> list[str]:
    """Message files that exist on a branch and nowhere in the local mailbox.
    This is the U10 case: a real report, correctly written, unreadable."""
    listing = git("ls-tree", "-r", "--name-only", branch, "AgentComms/messages/")
    local = {path.name for path in messages()}
    found = []
    for line in listing.splitlines():
        name = line.strip()
        if name.endswith(".json") and Path(name).name not in local:
            found.append(Path(name).name)
    return found


def collected_tips() -> dict[str, str]:
    """sha -> tag, for every `collected/*` tag. A branch tip in here was
    audited blob-by-blob against master and its content confirmed landed;
    the tag is what makes the branch recoverable after it is deleted."""
    out: dict[str, str] = {}
    for line in git("for-each-ref", "--format=%(objectname) %(refname:short)",
                    "refs/tags/collected").splitlines():
        parts = line.split(None, 1)
        if len(parts) == 2:
            out[parts[0].strip()] = parts[1].strip()
    return out

def shallow_clone() -> bool:
    """True when this checkout was cloned with a depth limit.

    A cloud session gets a shallow clone, and a shallow master is GRAFTED:
    its history stops at the graft and no branch fetched past it shares an
    ancestor with it. `git branch --no-merged master` then lists EVERY
    branch, and `master..<branch>` - having no merge-base to subtract -
    counts the branch's whole history. On 2026-09-13 that printed 26
    branches holding "991 to 1711 commit(s) not on master", every one of
    them an artefact; the real answer was not knowable in that checkout at
    all. Divergence needs the shared history, so say so instead of
    reporting a number that is wrong."""
    if git("rev-parse", "--is-shallow-repository").strip() == "true":
        return True
    return (ROOT / ".git" / "shallow").exists()


def godot_missing() -> bool:
    """True when no Godot can be found, which makes this a cloud session.

    Added 2026-09-13, after a session started from the operator's phone was
    told to do S1f and could not run a single gate: check_scripts.py shells
    Godot --check-only, so with no Godot the PARSE GATE, every test and the
    measure tools are all out. The roadmap carries the full rule, but that
    prints far down the report and this has to be seen. Report only - `start`
    makes no network call and downloads nothing; it names the command."""
    if os.environ.get("GODOT_EXE") and Path(os.environ["GODOT_EXE"]).is_file():
        return False
    for candidate in ("/opt/godot/godot", "/usr/local/bin/godot"):
        if Path(candidate).is_file():
            return False
    if shutil.which("godot") or shutil.which("godot4"):
        return False
    windows = Path(os.environ.get("LOCALAPPDATA", "")) / "Programs" / "Godot"
    return not windows.is_dir()


def triage(args: argparse.Namespace) -> int:
    if not args.no_fetch:
        git("fetch", "--no-write-fetch-head", "origin", "--prune")
    findings = 0

    print("== unmerged remote branches ==")
    branches = unmerged_branches()
    tips = collected_tips()
    if not branches:
        print("  none")
    collected_rows = []
    shallow = shallow_clone()
    if shallow and branches:
        print("  SHALLOW CLONE - DIVERGENCE IS NOT KNOWABLE HERE, AND NOTHING BELOW")
        print("  IS A COLLECTION JOB. master is grafted, so no branch shares an")
        print("  ancestor with it and a commit count would be the branch's whole")
        print("  history, not its divergence. `git fetch --unshallow` first, or run")
        print("  the triage on the full checkout, before acting on any row.")
    master_total = master_commit_count()
    facts = {b: branch_facts(b, master_total) for b in branches}
    mail = branch_only_messages_bulk([b for b in branches if facts[b][1] not in tips])
    for branch in branches:
        when, tip, commits_n = facts[branch]
        if tip in tips:
            # Audited and collected: the content is on master and the tag
            # keeps the branch recoverable. Not a finding, but still shown -
            # a silently hidden branch is how the last pile-up started.
            # A tip sha is a tip sha at any depth, so this row stays true
            # on a shallow clone.
            collected_rows.append("  %s: COLLECTED (tag %s), safe to delete" % (branch, tips[tip]))
            continue
        counted = False
        if commits_n is not None:
            print("  %s: %d commit(s) not on master, last %s" % (branch, commits_n, when))
            findings += 1
            counted = True
        else:
            # No merge-base: either the graft above, or two genuinely
            # unrelated histories. Unaudited is not the same as uncollected,
            # and a wrong number reads as authority - print neither.
            why = "shallow graft" if shallow else "unrelated history"
            print("  %s: divergence unknown (%s), last %s" % (branch, why, when))
            if not shallow:
                findings += 1
                counted = True
        for name in mail.get(branch, []):
            # A message file on the branch and not in the mailbox is real at
            # any depth - the tree is there to read. Count it when the row
            # above could not be counted, so a shallow run still reports it.
            print("     BRANCH-ONLY MAIL: %s   <- inbox cannot see this" % name)
            if not counted:
                findings += 1
    for row in collected_rows:
        print(row)

    print("")
    print("== digests with no HANDOFF block ==")
    # `scan` compares against the Active claims slice alone, which reports
    # every swept task as an orphan - 41 of them on first run, all of them
    # archived and fine. A block that has been swept into HANDOFF_ARCHIVE.md
    # was still written, so the archive counts as told.
    slice_text = handoff_slice()
    archived = archived_statuses()
    orphans = [t["id"] for t in (parse_task(path) for path in task_files())
               if digest_exists(t["id"]) and t["id"] not in slice_text and t["id"] not in archived]
    print("  " + (", ".join(orphans) if orphans else "none"))
    findings += len(orphans)

    print("")
    print("== open tasks whose gate cannot run ==")
    broken = []
    for row in open_rows():
        text = (ROOT / row["path"]).read_text(encoding="utf-8", errors="replace")
        if not declares_ownership(text) or not owned_files(text):
            broken.append(row["id"])
    if broken:
        print("  " + ", ".join(broken))
        print("  `done --task` finds no owned files here and would report success on nothing.")
    else:
        print("  none")
    findings += len(broken)

    print("")
    print("== open blockers ==")
    open_blockers = [load(path) for path in blocker_files() if not load(path).get("resolved_at")]
    if not open_blockers:
        print("  none")
    for blocker in open_blockers:
        print("  [%s] %s" % (blocker.get("task"), blocker.get("why")))
        findings += 1

    print("")
    print("TRIAGE %d item(s) want a decision. Report only - nothing was written." % findings)
    return 0


# ---- start: the whole orientation in one command ----------------------------
# Written 2026-09-12 after a session read the ops board and still had to ask the
# operator what to do. The board renders roadmap.json for the OPERATOR's phone;
# it does not render `handover`, which is the half a SESSION needs. This prints
# both, plus the live board, so "what now" has one answer and it is on disk.
#
# It DERIVES everything. There is no copy of the roadmap in here - that is the
# failure U62 named ("every authored claim ships unbound to the one consumer
# that would falsify it") and it has cost this project nine defects in a day.

ROADMAP_JSON = ROOT / "AgentComms" / "roadmap.json"
ROSTER_JSON = ROOT / "AgentComms" / "roster.json"
QUESTIONS_JSON = ROOT / "AgentComms" / "questions.json"

def _rule(title: str) -> None:
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


def _write_json_atomic(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temp_name = tempfile.mkstemp(prefix=path.name + ".", suffix=".tmp", dir=str(path.parent))
    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as stream:
            json.dump(data, stream, indent=2, ensure_ascii=False)
            stream.write("\n")
        os.replace(temp_name, path)
    except BaseException:
        try: os.unlink(temp_name)
        except OSError: pass
        raise


def _consume_board_questions(path: Path = QUESTIONS_JSON, emit=print) -> None:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        data = {"questions": []}
    rows = data.get("questions", []) if isinstance(data, dict) else []
    if not isinstance(rows, list): rows = []
    ## S249: a comment with no option picked IS an answer (opsboard /api/answer saves it as `answer` + comment_only; a row that
    ## only carries a `comment`/`note` counts too) - it is printed as ANSWERED (comment) and never listed as open again.
    def _said(q: dict) -> str:
        for key in ("answer", "comment", "note"):
            if isinstance(q.get(key), str) and q[key].strip():
                return q[key]
        return ""
    normalised = False
    for q in rows:
        if isinstance(q, dict) and not (isinstance(q.get("answer"), str) and q["answer"].strip()) and _said(q):
            q["answer"], q["comment_only"] = _said(q), True  # the board (index.html: !q.answer = open) now agrees
            q.setdefault("seen_by_claude", False)
            normalised = True
    if normalised and not any(isinstance(q, dict) and _said(q) and not q.get("seen_by_claude", False) for q in rows):
        _write_json_atomic(path, data)
    answered = [q for q in rows if isinstance(q, dict) and _said(q) and not q.get("seen_by_claude", False)]
    opened = [q for q in rows if isinstance(q, dict) and not _said(q) and str(q.get("status", "")).lower() != "closed"]
    if answered:
        ## S182 (operator: "check answers on opsboard, always check that at session start"): S182 read the answer and never told him.
        emit("QUESTIONS ANSWERED ON THE BOARD - QUOTE EACH ANSWER IN YOUR FIRST MESSAGE AND ACT ON IT NOW (clear the blocker, start the task)")
        for q in answered:
            emit("  %s | %s | %s: %s | note: %s" % (q.get("id", "?"), q.get("text", ""), "ANSWERED (comment, no option picked)" if q.get("comment_only") else "ANSWERED", q.get("answer", ""), q.get("note") or ""))
        for q in answered:
            q["seen_by_claude"] = True
        _write_json_atomic(path, data)
    ## S181 (operator: "always ask for pending issues at start of new session"): the list alone was read and not asked.
    emit("QUESTIONS STILL OPEN - ASK THE OPERATOR EVERY ONE IN YOUR FIRST MESSAGE, beside the queue (he can also answer them on 8787/)")
    for q in opened:
        emit("  %s | %s" % (q.get("id", "?"), q.get("text", "")))
    if not opened:
        emit("  (none open - new questions go on the board: python Tools/agent_comms.py ask \"<text>\" --options \"a|b\")")


def _consume_media_comments(path: Path = ROOT / "AgentComms" / "media_comments.json", emit=print) -> None:
    ## S192 operator: "i want to be able to see those [stills/videos] on the opsboard to make comments" (8787/review).
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return
    rows = [c for c in data.get("comments", []) if isinstance(c, dict) and not c.get("seen_by_claude", False)]
    if not rows:
        return
    emit("COMMENTS ON STILLS/VIDEOS (8787/review) - QUOTE EACH IN YOUR FIRST MESSAGE, OPEN THE FILE, ACT ON IT")
    for c in rows:
        at = (" at %ss" % c["at_s"]) if "at_s" in c else ""
        done = (" | ADDRESSED (%s)" % c["addressed"]) if c.get("addressed") else ""  # S249: board_reconcile, a master commit cites it
        emit("  %s | %s%s | %s%s" % (c.get("id", "?"), c.get("path", ""), at, c.get("text", ""), done))
        c["seen_by_claude"] = True
    _write_json_atomic(path, data)


def _ask_cmd(args: argparse.Namespace) -> int:
    ## S191 operator rule: an approval he cannot see on the board is not askable.
    if re.search(r"approv", args.text + " " + args.options, re.IGNORECASE) and not args.attach.strip():
        print("REFUSED: an approval question needs --attach <the doc/still he approves> (operator S191: 'i want to be able to see it on the opsboard')")
        return 2
    print("Added " + ask_question(args.text, args.options, attach=args.attach))
    return 0


def ask_question(text: str, options: str = "", path: Path = QUESTIONS_JSON, attach: str = "") -> str:
    if not text.strip():
        raise ValueError("question text is required")
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        data = {"_doc": "Questions for the FightCamp operator", "questions": []}
    rows = data.setdefault("questions", [])
    sessions = [m.group(1) for q in rows if isinstance(q, dict) and (m := re.fullmatch(r"Q-(S\d+)-\d+", str(q.get("id", ""))))]
    ## S181: the roadmap names the session ("updated": "2026-10-09 S181"); the last question's session was a stale guess (Q-S179-2 in S181).
    roadmap_session = ""
    try:
        found = re.search(r"(S\d+)", str(json.loads((ROOT / "AgentComms" / "roadmap.json").read_text(encoding="utf-8")).get("updated", "")))
        roadmap_session = found.group(1) if found else ""
    except (OSError, json.JSONDecodeError, AttributeError):
        roadmap_session = ""
    session = os.environ.get("FIGHTCAMP_SESSION", "").strip() or roadmap_session or (sessions[-1] if sessions else "S178")
    prefix = f"Q-{session}-"
    numbers = [int(q["id"][len(prefix):]) for q in rows if isinstance(q, dict) and str(q.get("id", "")).startswith(prefix) and str(q["id"][len(prefix):]).isdigit()]
    question_id = f"{prefix}{max(numbers, default=0) + 1}"
    choices = [item for item in options.split("|") if item] if options else []
    ## S191 operator: "when i need to approve something i want to be able to see it on the opsboard" - attachments are repo paths
    ## (a .md shows as a readable document, an image inline) that the board renders under the question.
    attached = [item.strip().replace("\\", "/") for item in attach.split("|") if item.strip()] if attach else []
    ## S220 operator Q-S212-17: "attachment does not work" - an E:/ path passed is_file() but the board serves only
    ## Tools/opsboard/attach_view.py ATTACH_ROOTS; anything else is copied into AgentComms/board_attach/ first.
    board_roots = ("research/", "Godot/docs/", "Godot/concepts/", "AgentComms/")
    for index, item in enumerate(attached):
        source = ROOT / item
        if not source.is_file():
            raise ValueError(f"attachment not found: {item}")
        rel = source.resolve().relative_to(ROOT.resolve()).as_posix() if source.resolve().is_relative_to(ROOT.resolve()) else ""
        if not rel.startswith(board_roots):
            copy_dir = ROOT / "AgentComms" / "board_attach"
            copy_dir.mkdir(parents=True, exist_ok=True)
            target = copy_dir / f"{question_id}_{index}_{source.name}"
            shutil.copy2(source, target)
            rel = target.relative_to(ROOT).as_posix()
        attached[index] = rel
    rows.append({"id": question_id, "asked": datetime.now(timezone.utc).isoformat(), "session": session,
                 "text": text.strip(), "options": choices, "attach": attached, "answer": None, "note": None,
                 "answered_at": None, "seen_by_claude": False})
    _write_json_atomic(path, data)
    return question_id

_BRIEF_PATH_RE = re.compile(r"[A-Za-z0-9_./-]+\.(?:md|py|gd|json|tscn|cmd)")


_NOT_DECISIVE = (
    "has not picked", "have not picked", "not yet greenlit", "not greenlit",
    "awaiting the operator", "awaits the operator", "operator has not",
    "or back to", "see `blocked_on_operator`", "see blocked_on_operator",
)
## "which option" was in this list for one revision and was REMOVED: the
## corrected `now` that fixed the original defect says "DO NOT ASK WHICH
## OPTION", so the phrase appears in decisive text as readily as in
## indecisive text. A lint that fires on the very sentence written to obey it
## teaches the next session to ignore the lint, which is worse than no lint.
## Every phrase left here asserts that a choice is OPEN; none of them can be
## written by an author who has already decided.


## OPERATOR RULE 2026-09-25 (S73): "in all researches i want this questioned and
## answered : what a human would do ?". Every task file and research brief
## assigned from S73 on carries a section answering how a real professional
## (animator, matchmaker, promoter, coach, fighter) actually does the thing,
## BEFORE a method is chosen. The rule was earned the hard way: the colour-suit
## route copied one piece of the studio mocap pipeline and skipped the rest.
## A written rule drifts, so `start` lists every S73+ file that lacks it.
_HUMAN_RE = re.compile(r"what (would|does|do) (a )?(real )?(human|professional|people)", re.I)
## "Assigned S101" AND "Assigned 2026-09-27 (S101)" - the second is how task
## files are actually written, and the old pattern skipped every one of them.
_ASSIGNED_RE = re.compile(r"Assigned[^\n]{0,40}?\bS(\d+)\b")
HUMAN_RULE_FROM_SESSION = 73


## S358: the brief checks below flagged briefs already ANSWERED (J_COMBOENERGY1_JOHN.md beside TASK_J_COMBOENERGY1.md) or
## cancelled - nobody acts on a dead brief, so the warning only buried the live ones. A brief is done when it says
## `Status: CANCELLED|DONE` or its answer file `<ID>_<SEAT>.md` sits beside it in research/.
_DONE_STATUS_RE = re.compile(r"^Status:\s*(CANCELLED|DONE|SUPERSEDED)", re.I | re.M)


def _brief_done(path, text: str) -> bool:
    if _DONE_STATUS_RE.search(text):
        return True
    stem = path.stem[5:] if path.stem.startswith("TASK_") else ""
    return bool(stem) and any(RESEARCH.glob(stem + "_*.md"))


def missing_human_question() -> list:
    out = []
    for path in sorted(list(RESEARCH.glob("TASK_*.md")) + list(RESEARCH.glob("*_BRIEF.md"))):
        text = path.read_text(encoding="utf-8", errors="replace")
        m = _ASSIGNED_RE.search(text)
        if not m or int(m.group(1)) < HUMAN_RULE_FROM_SESSION:
            continue
        if _brief_done(path, text):
            continue
        if not _HUMAN_RE.search(text):
            out.append(path.name)
    return out


def _warn_missing_human_question():
    missing = missing_human_question()
    if not missing:
        return
    print()
    print(_wrap(
        "!! RESEARCH DEFECT - %d brief(s) assigned from S73 on never ask WHAT WOULD A HUMAN DO "
        "(operator rule 2026-09-25): %s. Add a '## What would a human do?' section - how the real "
        "professional does this job - before the agent picks a method." % (len(missing), ", ".join(missing)),
        indent="  "))


## OPERATOR RULE 2026-09-27 (S101): "when we decide to add something new always
## check for prefabs etc". S101 was about to build an active ragdoll from scratch
## when a search found Kickback (MIT, Godot 4.7, Euphoria-like). Every task file
## and brief assigned from S101 on carries a '## Prefab check' section: what
## ready-made asset, plugin, library, dataset or pack exists (Godot Asset Library,
## GitHub, Unity/Unreal stores for ideas, itch.io, Fab, Mixamo), its licence, and
## why it is used or not. "None: this fixes our own engine" is a valid answer -
## an empty section is not.
_PREFAB_RE = re.compile(r"^##\s*Prefab check", re.I | re.M)
PREFAB_RULE_FROM_SESSION = 101


def missing_prefab_check() -> list:
    out = []
    for path in sorted(list(RESEARCH.glob("TASK_*.md")) + list(RESEARCH.glob("*_BRIEF.md"))):
        text = path.read_text(encoding="utf-8", errors="replace")
        m = _ASSIGNED_RE.search(text)
        if not m or int(m.group(1)) < PREFAB_RULE_FROM_SESSION:
            continue
        if _brief_done(path, text):
            continue
        if not _PREFAB_RE.search(text):
            out.append(path.name)
    return out


def _warn_missing_prefab_check():
    missing = missing_prefab_check()
    if not missing:
        return
    print()
    print(_wrap(
        "!! PREFAB DEFECT - %d brief(s) assigned from S101 on have no '## Prefab check' (operator rule "
        "2026-09-27: always check for prefabs before building something new): %s. Name what ready-made "
        "asset/plugin/library exists, its licence, and why it is or is not used." % (len(missing), ", ".join(missing)),
        indent="  "))


## S218 (operator PDFs, S217 "wtf is that" hook accepted on arm shape alone): every animation / body / look brief
## carries the '## VISUAL GATE' block from .claude/skills/visual-gate/SKILL.md (red on the shipped clip first,
## game-camera stills via still_framing, gap/noses/wrists/feet per still, the operator closes it).
_VISUAL_GATE_RE = re.compile(r"^##\s*VISUAL GATE", re.I | re.M)
_VISUAL_TOPIC_RE = re.compile(r"\b(animation|clip|punch|hook|jab|guard pose|glove|metahuman|stills?|retarget|mocap)\b", re.I)
_BRIEF_SESSION_RE = re.compile(r"(?:Assigned[^\n]{0,40}?\bS(\d+)\b|^#\s*TASK[^\n]*\(S(\d+)\))", re.M)
VISUAL_GATE_FROM_SESSION = 218


def missing_visual_gate() -> list:
    out = []
    for path in sorted(RESEARCH.glob("TASK_*.md")):
        text = path.read_text(encoding="utf-8", errors="replace")
        m = _BRIEF_SESSION_RE.search(text)
        if not m or int(m.group(1) or m.group(2)) < VISUAL_GATE_FROM_SESSION:
            continue
        if _brief_done(path, text) or re.search(r"^Kind:\s*(research|content)", text, re.I | re.M):
            continue  # S358: a research/words brief cannot break a visual
        if len(_VISUAL_TOPIC_RE.findall(text)) >= 3 and not _VISUAL_GATE_RE.search(text):
            out.append(path.name)
    return out


def _warn_missing_visual_gate():
    missing = missing_visual_gate()
    if not missing:
        return
    print()
    print(_wrap(
        "!! VISUAL GATE DEFECT - %d animation/body/look brief(s) from S218 on have no '## VISUAL GATE' block: %s. "
        "Paste the brief block from .claude/skills/visual-gate/SKILL.md." % (len(missing), ", ".join(missing)),
        indent="  "))


## S241 (`start` took 5+ min on 2026-10-17): the network/subprocess parts of `start` are independent of each other, so
## `start` submits them to a small thread pool up front and each section awaits its own result at the same place it
## printed before - the output is unchanged, the waits overlap, and every one has a hard timeout so a dead service
## (the Grok Bot gateway, gh, git fetch) costs seconds and never blocks the orientation. Jobs never print.
RECONCILE_TIMEOUT = 90
GBOT_WAKE_TIMEOUT = 8
FETCH_TIMEOUT = 30
RESEARCH_CHECK_TIMEOUT = 90
TRIAGE_TIMEOUT = 120
_FETCHED = threading.Event()
_PREFETCH: dict = {}
_POOL = None


def _job_reconcile():
    """None when board_reconcile --apply ran, else the exception (TimeoutExpired included)."""
    try:
        subprocess.run([sys.executable, str(ROOT / "Tools" / "board_reconcile.py"), "--apply"], cwd=ROOT,
                       capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=RECONCILE_TIMEOUT,
                       creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
                       env={**os.environ, "FIGHTCAMP_FROM_START": "1"})
        return None
    except (OSError, subprocess.SubprocessError) as exc:
        return exc


def _job_gbot():
    tail = "   (Grok bots: python Tools/gbot.py <args>)"
    try:
        wake = subprocess.run(["node", str(ROOT / "Tools" / "gbot_wake.mjs")], cwd=ROOT, capture_output=True,
                              text=True, encoding="utf-8", errors="replace", timeout=GBOT_WAKE_TIMEOUT)
        return (wake.stdout.strip().splitlines() or ["GBOT WAKE FAIL no output: " + wake.stderr.strip()[:160]])[-1] + tail
    except subprocess.TimeoutExpired:
        return f"GBOT WAKE FAIL no answer in {GBOT_WAKE_TIMEOUT} s (gbot.py wakes + retries itself){tail}"
    except OSError as exc:
        return f"GBOT WAKE FAIL {exc}{tail}"


def _job_git():
    """(research check result, fetched). Fetch first so the research check sees the newest remote refs."""
    try:
        subprocess.run(["git", "-C", str(ROOT), "fetch", "--no-write-fetch-head", "origin", "--prune"], capture_output=True, text=True,
                       timeout=FETCH_TIMEOUT)
    except (OSError, subprocess.SubprocessError):
        pass
    finally:
        _FETCHED.set()
    try:
        return subprocess.run([sys.executable, str(ROOT / "Tools" / "research_sync.py"), "--check"], cwd=ROOT,
                              capture_output=True, text=True, timeout=RESEARCH_CHECK_TIMEOUT)
    except subprocess.TimeoutExpired:
        return None
    except OSError:
        return None


def _job_triage() -> str:
    """S301 (operator: "starting orientation went up again"): triage's 22 git calls (~4.5 s) ran serially at the end of
    `start`. It is report-only, so it runs here as its own process (stdout redirection is not thread-safe) once the
    "git" job's fetch is done, overlapping the other waits. Falls back to running in-process."""
    if "git" in _PREFETCH:
        _FETCHED.wait(FETCH_TIMEOUT + 5)
    try:
        run = subprocess.run([sys.executable, str(Path(__file__).resolve()), "triage", "--no-fetch"], cwd=ROOT,
                             capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=TRIAGE_TIMEOUT,
                             creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        if run.returncode == 0 and run.stdout.strip():
            return run.stdout
        why = "rc=%s %s" % (run.returncode, run.stderr.strip()[-160:])
    except (OSError, subprocess.SubprocessError) as exc:
        why = str(exc)[:160]
    if "triage" in _PREFETCH:  # in a pool thread: redirect_stdout would swallow the main thread's prints
        return "TRIAGE FAILED (%s) - run `python Tools/agent_comms.py triage --no-fetch` by hand\n" % why
    return _capture(triage, argparse.Namespace(no_fetch=True))


_JOBS = {"reconcile": _job_reconcile, "gbot": _job_gbot, "git": _job_git, "live": lambda: live_agent_runs(),
         "gh": lambda: _arena_prs(), "triage": _job_triage}


def _prefetch(names) -> None:
    global _POOL
    from concurrent.futures import ThreadPoolExecutor
    if _POOL is None:
        _POOL = ThreadPoolExecutor(max_workers=6, thread_name_prefix="start")
    for name in names:
        _PREFETCH[name] = _POOL.submit(_JOBS[name])


def _await(name: str):
    """The named job's result: from the pool when `start` prefetched it, else computed here (direct callers)."""
    fut = _PREFETCH.get(name)
    return fut.result() if fut is not None else _JOBS[name]()


def _collect_now():
    """S232 operator: "always collect at start of session". Reconcile every run LIVE (not the 30-min cache), sync the
    board, and print what landed or stopped FIRST - collecting is the session's first work, before any new assign."""
    try:
        err = _await("reconcile")
        if isinstance(err, subprocess.TimeoutExpired):
            print("COLLECT NOW: the live reconcile did not finish in %d s - rows below are from the last 30-min reconcile" % RECONCILE_TIMEOUT)
        elif err is not None:
            raise err
        data = json.loads((ROOT / "AgentComms" / "board_reconcile.json").read_text(encoding="utf-8"))
    except (OSError, ValueError, subprocess.SubprocessError) as exc:
        print("COLLECT NOW: board_reconcile failed (%s) - read live_runs.json by hand" % exc)
        return
    rows = data.get("rows", [])
    act = [r for r in rows if r.get("verdict") in ("landed", "merged", "dead")]
    ## a run marked landed/stale on an earlier pass is no longer reconciled - it waits in live_runs until collected
    try:
        reg = json.loads((ROOT / "AgentComms" / "live_runs.json").read_text(encoding="utf-8")).get("runs", {})
    except (OSError, ValueError):
        reg = {}
    seen = {r["id"] for r in rows}
    for run_id, info in reg.items():
        if isinstance(info, dict) and run_id not in seen and info.get("status") in ("landed", "stale"):
            act.append({"id": run_id, "agent": info.get("agent", ""), "verdict": "landed" if info["status"] == "landed" else "dead",
                        "why": str(info.get("reconciled", info.get("status")))})
    unread = [r for r in rows if r.get("verdict") == "unknown"]
    print("COLLECT NOW - FIRST WORK OF THE SESSION (operator S232: \"always collect at start of session\")")
    for r in act:
        what = {"landed": "COLLECT (diff + parse + test)", "merged": "close the run", "dead": "STOPPED - relaunch or close"}[r["verdict"]]
        print(_wrap("  %s %s [%s] %s - %s" % (what, r["id"], r.get("agent", ""), r.get("verdict"), r.get("why", "")), indent="    "))
    if unread:
        print(_wrap("  READ THEIR CHAT (no machine witness): " + ", ".join("%s [%s]" % (r["id"], r.get("agent", "")) for r in unread),
                    indent="    "))
    if not act and not unread:
        print("  nothing landed or stopped")


def _ready_to_collect(path: Path = ROOT / "AgentComms" / "collect_ready.json", emit=print) -> None:
    """S249: the 30-min reconcile (Tools/collect_ready.py) merges fast-lane PRs whose brief scope matches by itself; every other
    open PR waits here as a review packet with the one command to run."""
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return
    rows, merged = data.get("prs", []), data.get("merged", [])
    if not rows and not merged:
        return
    emit("READY TO COLLECT (Tools/collect_ready.py, %s) - open agent PRs the 30-min job did not merge by itself" % data.get("at", "?"))
    for m in merged:
        emit("  MERGED UNATTENDED #%s %s -> %s (%s)" % (m.get("pr"), m.get("task"), m.get("commit"), ", ".join(m.get("files", []))))
    for r in rows:
        emit(_wrap("  #%s %s | task %s | brief %s | %s | CI %s" % (
            r.get("pr"), str(r.get("title", ""))[:70], r.get("task") or "-", "MATCH" if r.get("brief_match") else "no match",
            r.get("diff_stat") or "-", ", ".join("%s %s" % (c.get("name"), c.get("state")) for c in r.get("ci", [])) or "none"), indent="    "))
        if r.get("why_not"):
            emit(_wrap("    why not unattended: " + "; ".join(str(w)[:120] for w in r["why_not"][:3]), indent="      "))
        elif not r.get("brief_match"):
            emit(_wrap("    why not unattended: " + str(r.get("brief_why", "")), indent="      "))
        emit("    -> " + str(r.get("command", "")))


def _seat_answers(emit=print) -> None:
    """S249: AgentComms/seat_queue.json (Tools/seat_queue.py) - chat-seat briefs the 30-min job sent; their answers land in
    research/<stem>.md. Each new answer is printed once."""
    try:
        import seat_queue
        rows = seat_queue.consume_answers()
        pending = seat_queue.pending()
    except Exception as exc:
        emit("SEAT QUEUE unreadable: %s" % exc)
        return
    if rows:
        emit("SEAT ANSWERS (chat seats, AgentComms/seat_queue.json) - OPEN EACH, VERIFY ITS SOURCES, COMMIT IT, ACT ON IT")
        for r in rows:
            emit("  %s [%s] %s -> %s" % (r.get("id"), r.get("seat"), r.get("brief"), r.get("answer")))
    if pending:
        emit(_wrap("  seat queue still working: " + "; ".join("%s [%s] %s" % (r.get("id"), r.get("seat"), r.get("status")) for r in pending),
                   indent="    "))


def _disk_and_retired(emit=print) -> None:
    """S249 operator ("auto-retire worktrees and gate clones from now on"): E: free space, what Tools/worktree_retire.py retired
    since the last start, and the worktrees it holds (dirty / unpushed work - collect or push it so they can go)."""
    try:
        import worktree_retire
        free, lines, held = worktree_retire.since_last_start()
    except Exception as exc:
        emit("DISK: worktree_retire unreadable (%s)" % exc)
        return
    emit("DISK E: %.1f GB free%s" % (free, "  !! LOW - under 30 GB" if 0 <= free < 30 else ""))
    for line in lines[-12:]:
        emit("  retired since last start: " + line)
    for line in held:
        emit("  " + line)


def _warn_board_reconcile():
    """S218: Tools/board_reconcile.py (task every 30 min) marks dead/landed runs; show what it found."""
    try:
        data = json.loads((ROOT / "AgentComms" / "board_reconcile.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return
    rows = [r for r in data.get("rows", []) if r.get("verdict") in ("dead", "landed", "merged")]
    if not rows:
        return
    print()
    print(_wrap("!! BOARD RECONCILE (%s): %s - collect or close these runs in live_runs.json." % (
        data.get("at", "?"), "; ".join("%s %s (%s)" % (r["id"], r["verdict"], r["why"]) for r in rows)), indent="  "))


## OPERATOR RULE 2026-09-27 (S114): "i am sure this research has been done at
## least 3 times already" / "this is violation of the rules". G145 was sent to
## Grok with no search; J20/J33/G141/G143/G138 already held it. The check-the-
## record rule was prose, so it is a gate now, and one that DERIVES: the
## '## Prior research' section must name at least one file that exists in
## research, or show the search it ran ('searched: <terms>', from
## `python Tools/prior_research.py <terms>`). A bare "None" does not pass.
_PRIOR_RE = re.compile(r"^##\s*Prior research[^\n]*\n(.*?)(?=^##\s|\Z)", re.I | re.M | re.S)
_CITED_RE = re.compile(r"\b([A-Z][A-Za-z0-9_]*\.md)\b")
PRIOR_RULE_FROM_SESSION = 114


def prior_research_defects() -> list:
    out = []
    for path in sorted(list(RESEARCH.glob("TASK_*.md")) + list(RESEARCH.glob("*_BRIEF.md"))):
        text = path.read_text(encoding="utf-8", errors="replace")
        m = _ASSIGNED_RE.search(text)
        if not m or int(m.group(1)) < PRIOR_RULE_FROM_SESSION:
            continue
        if _brief_done(path, text):
            continue
        section = _PRIOR_RE.search(text)
        if not section:
            out.append(path.name + " (no section)")
            continue
        body = section.group(1)
        cited = [c for c in _CITED_RE.findall(body) if (RESEARCH / c).exists() and c != path.name]
        cited += [t for t in re.findall(r"topics/([a-z_]+)\.md", body) if (RESEARCH / "topics" / (t + ".md")).exists()]
        primary = [c for c in _CITED_RE.findall(body) if (RESEARCH / c).exists() and c != path.name]
        if not cited and not re.search(r"searched:\s*\S", body, re.I):
            out.append(path.name + " (names no existing study and no search)")
        elif cited and not primary and not re.search(r"searched:\s*\S", body, re.I):
            ## S114: topic pages are summaries - a brief must name at least one PRIMARY study it opened.
            out.append(path.name + " (cites only topic pages - name the primary study you opened)")
    return out


def _warn_prior_research():
    bad = prior_research_defects()
    if not bad:
        return
    print()
    print(_wrap(
        "!! PRIOR-RESEARCH DEFECT - %d brief(s) from S114 on do not show the record was checked (operator "
        "2026-09-27: research re-assigned that was 'done at least 3 times already'): %s. Run "
        "`python Tools/prior_research.py <terms>` and put the studies it finds - or 'searched: <terms>' - "
        "under '## Prior research'. Ask only for what those studies do not already answer."
        % (len(bad), "; ".join(bad)), indent="  "))



## S249 (operator asked how to stop Claude being the bottleneck on agent PRs): review moves to BRIEF time. Every brief written from
## 2026-10-18 on carries a `## Contract` block (OWNS / RED_TEST / REGRESSION / VISUAL) - Tools/code_gate.py merges a code PR only
## against it, so a brief without one can never merge unattended. Checker: Tools/brief_contract.py.
def _warn_brief_contract():
    try:
        sys.path.insert(0, str(ROOT / "Tools"))
        import brief_contract
        bad = brief_contract.defects()
    except Exception as exc:  # the warning must never break `start`
        print(f"\n  (brief contract check skipped: {exc})")
        return
    if not bad:
        return
    print()
    print(_wrap(
        "!! CONTRACT DEFECT - %d brief(s) from S249 on have no valid '## Contract' block (OWNS / RED_TEST / REGRESSION / VISUAL; "
        "without it the PR cannot merge unattended - Tools/code_gate.py): %s. Fix: `python Tools/brief_contract.py check <id>`."
        % (len(bad), "; ".join(bad)), indent="  "))

## OPERATOR 2026-09-27 (S114): "we agreed on a procedure, what does it mean to drop, who dropped it and why". The
## colour-suit route was marked "parked" in S73/S75 and then vanished from every handover - Claude dropped it with no
## decision. A task whose OWN digest says it is parked / stopped / incomplete / not accepted / not proven must have an
## entry in AgentComms/route_decisions.json: RESUMED (carried by which task, which owner) or STOPPED (why, by whom).
_DROP_CUE = re.compile(r"\b(parked|paused|is NOT complete|not complete|incomplete|not accepted|NOT delivered|NOT proven|"
                       r"not visually acceptable|stopped at)\b", re.I)
DROP_RULE_FROM_DATE = "2026-09-20"


def dropped_routes() -> list:
    decisions = {}
    path = ROOT / "AgentComms" / "route_decisions.json"
    if path.exists():
        decisions = json.loads(path.read_text(encoding="utf-8")).get("routes", {})
    out = []
    for p in sorted(RESEARCH.glob("*_DIGEST.md")):
        tid = p.name[: -len("_DIGEST.md")]
        if not re.fullmatch(r"[CQUG]\d{2,3}[A-Z]?", tid) or tid in decisions:
            continue
        text = p.read_text(encoding="utf-8", errors="replace")
        m = re.search(r"2026-(\d\d)-(\d\d)", text)
        if m and "2026-%s-%s" % m.groups() < DROP_RULE_FROM_DATE:
            continue
        head = "\n".join(text.splitlines()[:40])
        if _DROP_CUE.search(head) and "fight_pair_live" not in head:
            out.append(tid)
    return out


def _print_workflow():
    """The operator's controls (S115): active milestone + its finish line, and any record defect."""
    rel = {}
    try:
        rel = json.loads((ROOT / "AgentComms" / "roadmap.json").read_text(encoding="utf-8")).get("release", {})
    except Exception:
        pass
    try:
        stages = json.loads((ROOT / "AgentComms" / "roadmap.json").read_text(encoding="utf-8")).get("stages", [])
    except Exception:
        stages = []
    for m in stages:
        if str(m.get("state", "")).upper() == "ACTIVE":
            _rule("ACTIVE STAGE %s - %s (the ops board roadmap; every task must advance it, the rest is backlog)"
                  % (m.get("id"), m.get("title")))
            am = m.get("active_milestone", {})
            if am:
                print(_wrap("ACTIVE MILESTONE: %s - %s" % (am.get("name"), am.get("agreed", "")), indent="  "))
                print(_wrap("FINISH LINE: " + am.get("finish_line", "?"), indent="  "))
                if am.get("note"):
                    print(_wrap("NOTE: " + am["note"], indent="  "))
            for d in m.get("done_when", []):
                print(_wrap("STAGE DONE WHEN: " + d, indent="  "))
            print(_wrap("EVIDENCE NOW: " + m.get("evidence_now", "?"), indent="  "))
    wf = subprocess.run([sys.executable, str(ROOT / "Tools" / "check_workflow.py")], cwd=ROOT, capture_output=True, text=True)
    if wf.returncode != 0:
        print()
        print(_wrap("!! WORKFLOW DEFECTS (ship refuses until fixed):", indent="  "))
        for line in wf.stdout.splitlines():
            if line.startswith("WORKFLOW DEFECT"):
                print(_wrap(line, indent="    "))


def _print_route_status():
    path = ROOT / "AgentComms" / "route_decisions.json"
    if not path.exists():
        return
    routes = json.loads(path.read_text(encoding="utf-8")).get("routes", {})
    live = {k: v for k, v in routes.items() if str(v.get("status", "")).upper() == "RESUMED"}
    if not live:
        return
    _rule("ROUTE STATUS - QUOTE THIS WORD FOR WORD; NEVER DESCRIBE A ROUTE FROM MEMORY (operator 2026-09-28)")
    for rid, r in live.items():
        name = r.get("name", rid)
        print(_wrap("%s  %s  (carried by %s, %s)" % (rid, name, r.get("carried_by", "?"), r.get("owner", "?")), indent="  "))
        if r.get("proven"):
            print(_wrap("PROVEN: " + r["proven"], indent="      "))
        if r.get("open"):
            print(_wrap("OPEN:   " + r["open"], indent="      "))
        if not r.get("proven") and not r.get("open"):
            print(_wrap("!! no proven/open recorded - read its digest and fill both before speaking about it", indent="      "))


def _warn_dropped_routes():
    bad = dropped_routes()
    if not bad:
        return
    print()
    print(_wrap(
        "!! DROPPED-ROUTE DEFECT - %d task(s) whose own digest says parked / stopped / incomplete have no decision in "
        "AgentComms/route_decisions.json: %s. Write RESUMED (carried_by + owner) or STOPPED (why + who) for each - a "
        "route never leaves the handover without one (operator 2026-09-27)." % (len(bad), ", ".join(bad)), indent="  "))


def _warn_if_not_decisive(summary):
    """Shout if `now` reads like a question rather than a decision.

    THE RULE THIS ENFORCES IS OLDER THAN THE CHECK AND WAS BROKEN ANYWAY
    (operator, 2026-09-19: "I expect each session to be connected"). The
    2026-09-12 rule already said a session must never open by asking what to
    work on; S20's handover routed around it by filing the stage choice under
    `blocked_on_operator` and opening `now` with "THE OPERATOR HAS NOT PICKED
    THIS". The next session read that and asked. Prose did not hold, so the
    renderer checks.

    Deliberately a WARNING that still prints `now` rather than a hard failure:
    a session must never be left with nothing to do because its brief was
    written badly.
    """
    text = str(summary or "").lower()
    hits = [phrase for phrase in _NOT_DECISIVE if phrase in text]
    if not hits:
        return
    print()
    print(_wrap(
        "!! HANDOVER DEFECT - `now` READS LIKE A QUESTION, NOT A DECISION (matched: %s). "
        "**BUILD IT ANYWAY. DO NOT OPEN BY ASKING THE OPERATOR WHAT TO WORK ON** - that is "
        "the 2026-09-12 rule and the operator restated it on 2026-09-19 as \"I expect each "
        "session to be connected\". Take the most likely reading, say in one line which you "
        "took and why, and get on with it. Then FIX `now` so the next session is not put in "
        "the same position." % ", ".join(hits),
        indent="  "))


def _delegation_evidence(today=None):
    """S164 (operator: "a regular check which agents are available and use them, especially Arena which is free").
    A stage ships only if this day's live_runs.json holds a run handed to a non-Claude agent, or
    AgentComms/.no_delegation_reason was written today (one line: why nothing fit). Returns (ok, why)."""
    import datetime
    today = today or datetime.date.today().isoformat()
    try:
        runs = json.loads((ROOT / "AgentComms" / "live_runs.json").read_text(encoding="utf-8"))
        runs = runs.get("runs", runs) if isinstance(runs, dict) else {}
    except Exception:
        runs = {}
    for key, row in (runs.items() if isinstance(runs, dict) else []):
        if isinstance(row, dict) and str(row.get("agent", "")).lower() not in ("", "claude") and str(row.get("started", "")).startswith(today):
            return True, "delegated: %s -> %s" % (key, row.get("agent"))
    reason = ROOT / "AgentComms" / ".no_delegation_reason"
    if reason.exists() and datetime.date.fromtimestamp(reason.stat().st_mtime).isoformat() == today and reason.read_text(encoding="utf-8").strip():
        return True, "no delegation: " + reason.read_text(encoding="utf-8").strip()[:120]
    return False, "nothing was handed to an agent today"


def ship(args):
    """Mark this session as having shipped. The build tools refuse afterwards.

    CLAUDE.md has said "One session per stage. The moment a stage ships
    (commit pushed, digest written), end the session" since 2026-09-03. It
    was prose until a single session shipped FIVE stages on 2026-09-19, so it
    is a gate now. Call this once the digest is committed, then hand over.
    """
    ## 2026-09-27 (operator: "make sure all research done so far is always
    ## available to all agents"). A stage does not ship while any research
    ## document is off master, uncommitted, or missing from RESEARCH_INDEX.md.
    sync = subprocess.run([sys.executable, str(ROOT / "Tools" / "research_sync.py"), "--check"],
                          cwd=ROOT, capture_output=True, text=True)
    if sync.returncode != 0:
        print("SHIP REFUSED - research is not available to every agent yet:")
        print(sync.stdout.rstrip())
        print("  Fix: python Tools/research_sync.py, then commit research and RESEARCH_INDEX.md.")
        return 1
    ## OPERATOR CONTROLS 1-6 (S115, 2026-09-28): the release definition, one ACTIVE milestone, tasks mapped to it,
    ## a precise resume point and evidence before DONE are checked, not trusted. A stage does not ship past a defect.
    wf = subprocess.run([sys.executable, str(ROOT / "Tools" / "check_workflow.py")], cwd=ROOT, capture_output=True, text=True)
    if wf.returncode != 0:
        print("SHIP REFUSED - the workflow record is incomplete:")
        print(wf.stdout.rstrip())
        return 1
    ok_delegated, delegated_why = _delegation_evidence()
    if not ok_delegated:
        print("SHIP REFUSED - no delegation this session (AGENT SWEEP rule, operator S164): " + delegated_why)
        print("  Launch a free seat (Arena first) on a self-contained task and add it to AgentComms/live_runs.json,")
        print("  or write ONE line why nothing fit:  echo \"<reason>\" > AgentComms/.no_delegation_reason")
        return 1
    print("  " + delegated_why)
    import stage_gate
    session_id = stage_gate.mark_shipped()
    print("STAGE SHIPPED - session %s is finished." % session_id)
    print("  The parse gate and the suite now REFUSE further build work in this")
    print("  session. That is deliberate: a NEW stage is a NEW session.")
    print()
    print("  Hand the operator the block and stop:")
    print("    git pull && python ops/Tools/agent_comms.py start")
    print()
    print("  Work genuinely part of the SHIPPED stage - a red test you caused, a")
    print("  review reply - proceeds with FIGHTCAMP_STAGE_GATE=off, said out loud.")
    return 0


def _brief_paths(brief):
    """Repo-relative paths named in a `brief` value.

    `brief` is a path in some rows and a whole prose sentence naming several
    files in others, so a bare `(ROOT / brief).exists()` printed NOT WRITTEN
    YET over a spec that was on disk (2026-09-19, S18). Pull the path-like
    tokens out and judge each one; a brief that names none gets no verdict at
    all rather than a false one.
    """
    # S34: `brief` is a LIST in some rows (S33 wrote five research paths
    # as one) and a string in others. Flatten before matching rather than
    # forcing the data into the shape of the reader - a list crashed
    # `start` outright, half way through the orientation it exists to print.
    if isinstance(brief, (list, tuple)):
        brief = " ".join(str(b) for b in brief)
    seen, out = set(), []
    for tok in _BRIEF_PATH_RE.findall(brief or ""):
        tok = tok.strip("`'\",.()").lstrip("./")
        if tok and tok not in seen:
            seen.add(tok)
            out.append(tok)
    return out


def _wrap(text: str, indent: str = "  ", width: int = 76) -> str:
    return textwrap.fill(" ".join(str(text).split()), width=width,
                         initial_indent=indent, subsequent_indent=indent)

## ---------------------------------------------------------------------
## THE HANDOVER SELF-CHECK, MADE EXECUTABLE (operator, 2026-09-15)
##
## CLAUDE.md has always said "self-check before ending a session: if the
## operator took ONLY the block, would the next session have everything?" - and
## a self-check a human performs from memory is a promise, not a gate. On
## 2026-09-15 a session handed over a `now` that still said "launch C133" AFTER
## finishing C133, caught only because someone happened to look. The operator:
## "make sure it doesn't happen again."
##
## So it is a command now. `handover` refuses, loudly and with an exit code,
## when the thing the next session reads does not match the thing this session
## did. It checks what can actually be checked from disk rather than asking
## anyone to remember.


def _content_commits_since_roadmap() -> list[str]:
    """Commits that changed the PROJECT after the roadmap was last written.

    This is the staleness test that matters: `now` is read by the next session
    as the description of where the work stands, so any commit to Godot/ or
    Tools/ that lands after the last roadmap edit is a change nobody described.
    """
    marker = git("log", "-1", "--format=%H", "--", "AgentComms/roadmap.json").strip()
    if not marker:
        return []
    out = git("log", "--oneline", marker + "..HEAD", "--", ":(top)scripts", ":(top)scenes", ":(top)tests", ":(top)tools", "Tools")
    return [line for line in out.splitlines() if line.strip()]


def handover(args: argparse.Namespace) -> int:
    problems: list[str] = []
    notes: list[str] = []

    stale = _content_commits_since_roadmap()
    if stale:
        problems.append(
            "THE ROADMAP IS BEHIND THE CODE. %d commit(s) changed Godot/ or Tools/ after\n"
            "     AgentComms/roadmap.json was last written, so `now` describes a state that\n"
            "     no longer exists. Update now.status / now.summary, then re-run.\n%s"
            % (len(stale), "\n".join("       " + line for line in stale[:8])))

    dirty = git("status", "--porcelain").strip()
    if dirty:
        problems.append("THE TREE IS DIRTY - the next session would not get this work:\n%s"
                        % "\n".join("       " + line for line in dirty.splitlines()[:8]))

    branch = git("rev-parse", "--abbrev-ref", "HEAD").strip()
    ahead = git("rev-list", "--count", "@{u}..HEAD").strip() if branch else ""
    if ahead and ahead != "0":
        problems.append("%s COMMIT(S) ARE NOT PUSHED - a container is ephemeral and this work\n"
                        "     exists nowhere else." % ahead)
    elif not ahead:
        notes.append("no upstream for %s - could not check whether it is pushed" % (branch or "?"))

    try:
        unparsed = unparsed_task_headers(handoff_slice())
    except Exception:
        unparsed = []
    if unparsed:
        problems.append(
            "A HANDOFF BLOCK'S STATUS CANNOT BE PARSED, so its task keeps whatever status\n"
            "     the board already had - a finished task silently reads OPEN:\n%s"
            % "\n".join("       " + h[:96] for h in unparsed[:5]))

    unread = 0
    try:
        messages = sorted(MESSAGES.glob("*.json")) if MESSAGES.is_dir() else []
        acked = {p.name.split("__")[0] for p in ACKS.glob("*__claude.json")} if ACKS.is_dir() else set()
        for path in messages:
            ident = path.stem.rsplit("_", 1)[-1]
            if "_to_claude_" in path.name and ident not in acked:
                unread += 1
    except Exception:
        unread = 0
    if unread:
        notes.append("%d unread message(s) for claude - `inbox --agent claude`" % unread)

    _rule("HANDOVER SELF-CHECK")
    if problems:
        for item in problems:
            print("  FAIL " + item)
    for note in notes:
        print("  note " + note)
    if problems:
        print("\n  NOT READY TO HAND OVER: %d problem(s) above. Fix them, then re-run." % len(problems))
        return 1

    print("  roadmap describes HEAD, tree clean, branch pushed, every HANDOFF header parses.")
    print("\n  THE PROMPT - this is the whole handover, nothing else is load-bearing:")
    print("")
    merge = ""
    if branch and branch != "main":
        merge = "git fetch origin && git merge --no-ff origin/%s && " % branch
    print("    %spython Tools/agent_comms.py start" % (merge or "git pull && "))
    print("")
    return 0


## LIVE AGENT RUNS (operator 2026-09-25, after a new session called two running
## agents "stopped" from a process scan that missed them, then deferred to the old
## session instead of owning them: "you should handle new sessions properly ... if
## you leave agents running and you won't [know] about it in the new session").
## The operator opens NEW sessions rather than clearing, so a run launched by the
## last session is in flight when this one starts. Evidence is the worktree, not a
## process name: a file written in the last LIVE_MINUTES under an agent worktree
## (the .godot cache excluded) means the agent is working there right now.
LIVE_MINUTES = 45


def live_agent_runs() -> list[tuple[str, str, float, int]]:
    rows = []
    try:
        listing = git("worktree", "list", "--porcelain")
    except Exception:
        return rows
    path, branch = "", ""
    blocks = listing.split(chr(10) * 2)
    now = time.time()
    for block in blocks:
        path = branch = ""
        for line in block.splitlines():
            if line.startswith("worktree "):
                path = line[9:].strip()
            elif line.startswith("branch "):
                branch = line[7:].strip().replace("refs/heads/", "")
        if not path or Path(path).resolve() in (ROOT.resolve(), GAME.resolve()):  # S366: the main checkout is GAME
            continue
        ## S139 (operator: "make sure there is nothing on d that we use"): the D: HDD is failing and its reads freeze
        ## the PC; no agent runs there since S138 (worktrees on E:), so its 25 old worktrees are never scanned.
        if path[:2].upper() == "D:":
            continue
        ## S138: newest = HEAD's commit time or the mtime of a file git calls changed/untracked. The old os.walk +
        ## getmtime over every file of 24 worktrees on the D: HDD held `start` for 10+ minutes.
        newest = 0.0
        try:
            newest = float(subprocess.run(["git", "-C", path, "log", "-1", "--format=%ct"], capture_output=True,
                                          text=True, timeout=60).stdout.strip() or 0)
            changed = subprocess.run(["git", "-C", path, "status", "--porcelain", "-uall"], capture_output=True,
                                     text=True, timeout=120).stdout
        except (subprocess.TimeoutExpired, ValueError, OSError):
            changed = ""
        for line in changed.splitlines():
            rel = line[3:].split(" -> ")[-1].strip().strip('"')
            if not rel or ".godot" in rel:
                continue
            try:
                newest = max(newest, os.path.getmtime(os.path.join(path, rel)))
            except OSError:
                pass
        age_min = (now - newest) / 60.0 if newest else 1e9
        if age_min <= LIVE_MINUTES:
            dirty = subprocess.run(["git", "-C", path, "status", "-s", "-uno"],
                                   capture_output=True, text=True).stdout
            rows.append((branch, path, age_min, len([l for l in dirty.splitlines() if ".godot" not in l])))
    return rows


## S127 compact `start` helpers. A queue row is CLOSED when its state opens with a finished word.
## S201: the newest tag leads a state ("[[S200 DONE] ..."), so a stage id may sit before the verdict word; without
## it 30+ finished rows printed as OPEN and the queue block alone cost ~9k tokens of every session start.
## S220 operator "act on this tighten the scope": PARKED rows (queue.focus_rule) leave the compact list too; `start --full` keeps them.
_CLOSED_STATE = re.compile(r"^\[*\s*(S\d+[a-z]?\s*[:-]?\s*)?(DONE|MERGED|COLLECTED|REJECTED|TAKEN OVER|PARTLY DONE|SUPERSEDED|PARKED)", re.I)


def _queue_closed(state: str) -> bool:
    return bool(_CLOSED_STATE.match(state.strip()))


def _capture(fn, *a) -> str:
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        fn(*a)
    return buf.getvalue()


## The workflow block: its first lines (the ACTIVE milestone) and EVERY warning line - a gate never goes quiet.
_WARN_LINE = re.compile(r"DEFECT|REFUS|FAIL|MISSING|WARNING|!!|NOT WRITTEN|VIOLAT", re.I)


def _print_workflow_compact() -> None:
    lines = _capture(_print_workflow).splitlines()
    for i, line in enumerate(lines):
        if i < 8 or _WARN_LINE.search(line):
            print(line)
    if len(lines) > 8:
        print("  (the whole milestone block: `start --full`)")


def _triage_compact(report: str) -> None:
    lines = report.splitlines()
    section, counts = "", {}
    for line in lines:
        if line.startswith("== "):
            section = line.strip("= ").strip()
            counts[section] = 0
        elif section and line.strip() and not line.strip().startswith("BRANCH-ONLY MAIL"):
            counts[section] = counts.get(section, 0) + 1
    for name, n in counts.items():
        print(f"  {n:>3}  {name}")
    for line in lines:
        if line.startswith("TRIAGE") or _WARN_LINE.search(line):
            print(line if len(line) <= 200 else line[:200] + " ...")
    print("  (the lists: `start --full` or `python Tools/agent_comms.py triage`)")


def start(args: argparse.Namespace) -> int:
    try:
        plan = json.loads(ROADMAP_JSON.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"CANNOT READ {ROADMAP_JSON.relative_to(ROOT)}: {exc}", file=sys.stderr)
        print("Everything below still works; the plan half is missing.", file=sys.stderr)
        plan = {}
    hand = plan.get("handover", {})
    ## S127 OPERATOR BRIEF (2026-09-29): "Cut `agent_comms.py start` to about 150 lines: objective, next action, runs in
    ## flight, OPEN queue items only, blockers." COMPACT is the default; `--full` prints everything it used to. Every
    ## gate (the DEFECT warnings, research sync, stage-gate minting, runs in flight, handover-key check) prints in BOTH.
    full = bool(getattr(args, "full", False))

    try:
        roster = json.loads(ROSTER_JSON.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        roster = {}
    available = [name for name, row in roster.items() if isinstance(row, dict) and row.get("in_rotation")]
    wants_gbot = any(n in available for n in ("kalli", "john", "maria"))
    _prefetch(["reconcile", "git", "live", "gh", "triage"] + (["gbot"] if wants_gbot else []))

    _consume_board_questions()
    _consume_media_comments()
    _collect_now()
    _ready_to_collect()
    _seat_answers()
    _disk_and_retired()
    ## S259: the nightly suite runs on GitHub runners (nightly-suite.yml) - bring its latest.txt onto the PC before anyone reads it.
    try:
        import nightly_fetch
        print(nightly_fetch.fetch() or "NIGHTLY (cloud) already fetched: " + (ROOT / "AgentComms" / "nightly" / "latest.txt")
              .read_text(encoding="utf-8-sig", errors="replace").splitlines()[0])
    except Exception as exc:  # never breaks start
        print("NIGHTLY_FETCH failed: %s" % exc)
    print("AVAILABLE AGENTS (operator ticks): " + (", ".join(available) if available else "none"))
    ## S180 (operator: "fix it once and for all"): the Grok Bot app parks its cloud pod when its window is unfocused,
    ## and bare gbot then fails "417 Expectation Failed" (pod_hibernated). Wake it here so Kalli/John/Maria are
    ## reachable from the first minute; drive them with `python Tools/gbot.py ...` (wakes + retries on a parked pod).
    if wants_gbot:
        print(_await("gbot"))
    ## S255 (operator: "why is this not fixed?" - Ziva sat ECONNREFUSED and was only reported): say it AND the fix.
    if "ziva" in available:
        import socket
        try:
            socket.create_connection(("127.0.0.1", 7012), timeout=1.0).close()
            print("ZIVA UP 127.0.0.1:7012 (shell bridge: python Tools/ziva_mcp.py run_scene '<json>' --out <dir>)")
        except OSError:
            ## S368: the Lean worktree is wt/ZIVA_LEAN, project.godot at its root (wt/ZIVA and its Godot/ went with the old repo).
            print("ZIVA DOWN - FIX IT NOW (watchdog not RED, no other Godot job): git -C E:/FightCamp/wt/ZIVA_LEAN fetch; put it on "
                  "origin/main (commit any dirty state to a local wip branch first); "
                  "powershell -NoProfile -ExecutionPolicy Bypass -File Tools\\godot_hidden.ps1 -e --path E:/FightCamp/wt/ZIVA_LEAN "
                  "--log-file E:/FightCamp/tmp/ziva_editor.log  (run in background; 7012 listens in ~1 min)")

    head = subprocess.run(["git", "log", "-1", "--format=%h %s"], cwd=ROOT,
                          capture_output=True, text=True).stdout.strip()
    _rule(f"FIGHTCAMP SESSION START   roadmap updated {plan.get('updated', '?')}")
    print(f"  HEAD  {head[:74]}")
    ## OPERATOR 2026-09-27 (S114): "you have 7 days to bring the game a playable demo, do you understand this will be
    ## remembered after 100 sessions?" The deadline is printed FIRST, every session, with the days left, so no
    ## session can open without it. Everything that is not on the road to the demo waits.
    ## OPERATOR 2026-09-28 (S115): the standing objective, printed FIRST every session.
    objective = plan.get("objective", {})
    if objective.get("text"):
        _rule("THE OBJECTIVE (%s)" % objective.get("set", "operator"))
        print(_wrap(objective["text"], indent="  "))
        if objective.get("where") and full:
            print(_wrap("WHERE: " + objective["where"], indent="  "))
        nxt = plan.get("now", {}).get("next_action")
        if nxt:
            print(_wrap("RECORDED NEXT ACTION - RESUME HERE: " + nxt, indent="  "))
    deadline = plan.get("deadline", {})
    if deadline.get("date"):
        try:
            left = (datetime.strptime(deadline["date"], "%Y-%m-%d").date() - datetime.now().date()).days
        except ValueError:
            left = None
        _rule("DEADLINE: %s - %s - %s DAY(S) LEFT" % (deadline.get("what", "?").upper(), deadline["date"],
                                                      "?" if left is None else left))
        print(_wrap(deadline.get("rule", ""), indent="  "))
        for item in deadline.get("road", []):
            print(_wrap("- " + item, indent="  "))
    ## OPERATOR 2026-09-28 (S115): "stop doing that every session, are you really inteligent ?" - after Claude told
    ## him video had "never turned into game motion" while route_decisions.json held the suit route RESUMED with its
    ## tracking PASSED. A route's status is QUOTED from here, never re-summarised from memory.
    if full:
        _print_route_status()
        _print_workflow()
    else:
        print("  ROUTE STATUS (quote it, never from memory): AgentComms/route_decisions.json or `start --full`")
        _print_workflow_compact()
    ## OPERATOR 2026-09-27 (S114): "on the session end list me the queued tasks and what everything does and on the
    ## new session state those tasks at the start so i can verify integrity". Printed here; the session's FIRST
    ## message repeats it to the operator before any work.
    queue = plan.get("queue", {}).get("tasks", [])
    if queue:
        shown = queue if full else [t for t in queue if not _queue_closed(str(t.get("state", "")))]
        _rule("QUEUED TASKS - STATE THESE TO THE OPERATOR IN YOUR FIRST MESSAGE, BEFORE ANY WORK"
              + ("" if full else "  (OPEN only: %d of %d; rows cut at 160 chars, `start --full` for all)" % (len(shown), len(queue))))
        for t in shown:
            row = "%-5s %-8s [%s] %s" % (t.get("id", "?"), t.get("owner", "?"), t.get("state", "?"), t.get("what", ""))
            if not full and len(row) > 160:
                row = row[:160] + " ..."
            print(_wrap(row, indent="  "))
    ## WHAT THIS BRANCH ALREADY CONTAINS. A session's context can be summarised
    ## away mid-flight - on 2026-09-15 one came back not knowing two of its own
    ## stages had landed and nearly handed over a stale prompt. Memory is not
    ## the record; the branch is. Printing it costs four lines and makes a
    ## resumed session correct by reading rather than by remembering.
    try:
        mine = [l for l in git("log", "--oneline", "origin/main..HEAD").splitlines() if l.strip()]
    except Exception:
        mine = []
    if mine:
        print(f"  THIS BRANCH ALREADY CONTAINS {len(mine)} commit(s) not on master:")
        for line in mine[:8]:
            print(f"    {line[:72]}")
        if len(mine) > 8:
            print(f"    ... and {len(mine) - 8} more - `git log --oneline origin/main..HEAD`")
    ## 2026-09-27: research every agent cannot reach is named at the top.
    sync = _await("git")
    if sync is None:
        _rule("RESEARCH CHECK DID NOT FINISH in %d s - run python Tools/research_sync.py --check" % RESEARCH_CHECK_TIMEOUT)
    elif sync.returncode != 0:
        _rule("RESEARCH NOT AVAILABLE TO EVERY AGENT - run python Tools/research_sync.py and commit")
        for line in sync.stdout.rstrip().splitlines()[:12]:
            print(line)
    live = _await("live")
    if live:
        _rule("AGENT RUNS IN FLIGHT - THEY ARE YOURS NOW")
        print("  The last session launched these and they are still writing files.")
        print("  YOU OWN THEM: do not relaunch, do not ask the old session, do not call")
        print("  them stopped. Collect each when it lands (its roster note says the")
        print("  merge bar), and name them in your handover block if still running.")
        for branch, path, age, dirty in live:
            print(f"    {branch:<34} last write {age:4.0f} min ago, {dirty} tracked edit(s)")
            print(f"      {path}")
    if godot_missing():
        print("")
        print("  !! NO GODOT ON THIS MACHINE - RUN THIS BEFORE ANYTHING ELSE:")
        print("        bash Tools/cloud_setup.sh")
        print("     Until you do, the PARSE GATE cannot run (it shells Godot")
        print("     --check-only) and neither can any test or measure tool, so")
        print("     every gated task below is undoable. ~12s, idempotent. Also")
        print("     read the LFS line it prints: animation and clip work cannot")
        print("     be done here at all.")

    ## ONE SESSION, ONE STAGE. Minting the id here is what lets the gate tell
    ## "THIS session already shipped" from "SOME session shipped today" - a
    ## date check would refuse the fresh session we actually want.
    try:
        import stage_gate
        stage_gate.begin_session()
    except Exception:
        pass

    now = plan.get("now") or {}
    if now:
        _rule("DO THIS NOW - this is the answer to \"what do I work on\"")
        stage = now.get("session") or now.get("stage") or "?"
        owner = now.get("owner", "?")
        print(f"  {stage}  [{owner}]  {now.get('title', '')}")
        for key in ("why", "summary", "detail", "body"):
            if now.get(key):
                print(_wrap(now[key]))
                _warn_if_not_decisive(now[key])
                break
        _warn_missing_human_question()
        _warn_missing_prefab_check()
        _warn_missing_visual_gate()
        _warn_board_reconcile()
        _warn_prior_research()
        _warn_brief_contract()
        _warn_dropped_routes()
        if now.get("gate"):
            print("\n  GATE")
            print(_wrap(now["gate"], indent="    "))
        rows = {str(s.get("id")): s for s in (plan.get("sessions") or [])}
        brief = now.get("brief") or (rows.get(stage) or {}).get("brief")
        if brief:
            if isinstance(brief, (list, tuple)):
                print("\n  BRIEF")
            else:
                print(f"\n  BRIEF  {brief}")
            for path in _brief_paths(brief):
                mark = "(on disk)" if (ROOT / path).exists() else "** NOT WRITTEN YET **"
                print(f"    {path}  {mark}")

    nxt = plan.get("next") or {}
    if isinstance(nxt, str):
        print("\n  THEN")
        print(_wrap(nxt, indent="    "))
    elif nxt:
        label = nxt.get('session') or nxt.get('stage') or '?'
        print(f"\n  THEN  {label}  {nxt.get('title', '')}")
        # S22: print the summary too. `next` is a DICT because
        # `Tools/render_roadmap.py` reads `.get("session"/"title"/"summary")`
        # off it and crashes on a string - which it had been doing silently,
        # leaving ROADMAP.md stale. Printing only the title here is what made
        # a string look like the better shape; now both forms carry everything.
        if nxt.get("summary"):
            print(_wrap(str(nxt["summary"]), indent="    "))

    blocked = plan.get("blocked_on_operator") or []
    if blocked:
        _rule("WAITING ON THE OPERATOR - ask ONCE, EARLY, and ALL TOGETHER")
        print(_wrap(
            "**NONE OF THESE GATE `now`. BUILD `now` FIRST AND RAISE THESE ALONGSIDE IT.** "
            "This section is for what the OPERATOR ALONE can supply - their eye on a "
            "recording, credits, a file that exists only on their machine, a product ruling "
            "nobody can derive. If an item here would change WHAT YOU BUILD, it is in the "
            "wrong place: decide it as lead developer, put the decision in `now`, and name "
            "the alternative as a fallback rather than a question (2026-09-19 - a stage "
            "choice was filed here and the next session opened by asking the operator what "
            "to build, which is the exact failure the 2026-09-12 rule exists to stop).",
            indent="  "))
        print()
        for item in blocked:
            print(f"  {item.get('id', '?')} blocks {item.get('blocks', '?')}")
            print(_wrap(item.get("question", ""), indent="    "))
        if hand.get("blocked_on_operator_detail"):
            print()
            print(_wrap(hand["blocked_on_operator_detail"], indent="  "))

    ## OPERATOR RULE 2026-09-22, VERBATIM: "i want a report on that task on
    ## every new session". It is CALLED here rather than written into the
    ## roadmap as prose, because a standing instruction with no mechanical
    ## gate behind it is one a session forgets - which is this project's own
    ## finding from 2026-09-19. `clip_status.report()` never raises and
    ## never invents a figure: every number is stamped with the commit it
    ## was measured at and prints STALE if anything that could move it has
    ## been committed since.
    try:
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        import clip_status
        if full:
            clip_status.report()
    except Exception as exc:  # never let the report break orientation
        print()
        print("  CASCADEUR CLIP REPORT UNAVAILABLE: %s" % exc)
        print("  The operator asked for this every session - fix it, do not"
              " skip it. `python Tools/clip_status.py report`")

    _rule("UNCOLLECTED - collect before you assign anything new")
    ## the fetch already ran in the "git" job above (S241), so triage must not fetch a second time; S301: the "triage"
    ## job ran it in the pool right after that fetch
    report = _await("triage")
    if full:
        print(report, end="")
    else:
        _triage_compact(report)

    _rule("AGENTS - you drive every one of them, in this console, no human relay")
    try:
        roster = json.loads(ROSTER_JSON.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        roster = {}
    # handoff_statuses(), not statuses_in(handoff_slice()): the slice stops at
    # "## Direction notes" and a stage that shipped today is below it, so this
    # line used to report a finished task as still held.
    statuses = handoff_statuses() | archived_statuses()
    open_by_agent: dict[str, list[str]] = {}
    for task in (parse_task(p) for p in task_files()):
        if status_of(task["id"], statuses) == "OPEN":
            open_by_agent.setdefault(task["agent"], []).append(task["id"])
    how = hand.get("agents", {})
    # roster.json also carries a top-level "note" string (CLAUDE.md s3: name
    # every run in flight there); only dict entries are agents.
    agent_names = {k for k, v in roster.items() if isinstance(v, dict)}
    for name in sorted(agent_names | set(open_by_agent)):
        entry = roster.get(name, {})
        if not isinstance(entry, dict):
            entry = {}
        rota = "IN " if entry.get("in_rotation") else "OUT"
        held = ", ".join(sorted(open_by_agent.get(name, []))) or "-"
        if not full:
            if rota == "IN ":
                note = " ".join(str(how.get(name, "")).split())
                print(f"  {name:<7} IN   " + ((note[:150] + (" ..." if len(note) > 150 else "")) if note else "holds: " + held[:120]))
            continue
        print(f"  {name:<7} {rota}  holds: {held}")
        if how.get(name):
            print(_wrap(how[name], indent="          "))
    if not full:
        print("  (OUT agents, task holdings, SETTINGS, traps, already-decided, ending duties: `start --full`)")
    _arena_status()
    if full and hand.get("you_drive_every_agent"):
        print()
        print(_wrap(hand["you_drive_every_agent"], indent="  "))

    settings = hand.get("settings") or {}
    if settings and full:
        _rule("SETTINGS - fixed at assignment; no agent self-escalates")
        for who, value in settings.items():
            print(f"  {who:<14} {value}")

    for key, title in (("rules_this_session_earned", "RULES THE LAST SESSION EARNED - these are the expensive ones"),
                       ("traps_that_each_cost_a_pass", "TRAPS THAT EACH COST A PASS"),
                       ("already_decided_do_not_reask", "ALREADY DECIDED - DO NOT RE-ASK")):
        value = hand.get(key)
        if not value or not full:
            continue
        _rule(title)
        for item in (value if isinstance(value, list) else [value]):
            print(_wrap(f"- {item}"))

    ## HANDOVER KEYS THIS COMMAND DOES NOT PRINT ARE INVISIBLE, AND A SESSION
    ## CANNOT TELL FROM THE OUTSIDE WHICH THOSE ARE.
    ##
    ## CLAUDE.md has warned since 2026-09-19 that "handover notes written to a
    ## key `start` never prints" is one of the unenforced rules that got routed
    ## around - and on 2026-09-21 S40 did exactly that FOUR TIMES in one
    ## session, inventing `session_memory_...`, `CHECK_THE_PERCHANCE_...` and
    ## two more, verifying none of them, and only noticing because it grepped
    ## its own output. The whitelist above is deliberate - 79 keys would be a
    ## wall - so the fix is not to print everything. It is to SAY the silent
    ## ones exist and name the newest, which are the ones a session has just
    ## written. Insertion order in the JSON is chronological.
    rendered = {"blocked_on_operator_detail", "agents", "you_drive_every_agent",
                "settings", "ending_a_session", "rules_this_session_earned",
                "traps_that_each_cost_a_pass", "already_decided_do_not_reask",
                "how_to_use", "start_sequence", "uncollected_deliverables",
                "in_flight_uncommitted", "ops_board_caveat"}
    orphans = [k for k in hand.keys() if k not in rendered]
    if orphans:
        print("")
        print(f"  NOTE  {len(orphans)} `handover` key(s) are NOT printed by this")
        print("        command, so a session never sees them. Newest first:")
        for key in list(reversed(orphans))[:4]:
            print(f"          {key}")
        print("        Anything the NEXT session must read belongs in")
        print("        `already_decided_do_not_reask`, `traps_that_each_cost_a_pass`")
        print("        or `rules_this_session_earned` - nothing else renders.")

    # S385 operator: "i want a map similar to this for this project, needs to be updated on every session end or start".
    _rule("P0 WHERE WE ARE (Miro) - redraw it NOW and again at your wrap-up")
    try:
        import where_we_are  # noqa: PLC0415
        c = where_we_are.cards()
        for k, title in (("done_session", "DONE in " + (c["session"] or "?")), ("now", "NOW"), ("next", "NEXT")):
            print(f"  {title}: " + " | ".join(x["text"] for x in c[k]))
    except Exception as exc:  # noqa: BLE001
        print(f"  where_we_are failed: {exc}")
    print("  START: python Tools/where_we_are.py roll S<n>  (this session's DONE -> Earlier), `now` your work, then")
    print("         python Tools/where_we_are.py svg -> one canvas_update_from_svg (recipe: Tools/where_we_are_svg.py docstring).")
    print("  END:   `done` each finished item (<= 34 chars), `drop` stale NOW/NEXT, `next` new ones, redraw the same way.")
    if not full:
        _rule("END OF SESSION")
        print("  A stage ships whole (digest, roadmap now, queue, memory, `ship`); the last message is the queue, then ONE")
        print("  bash block: `git pull && python ops/Tools/agent_comms.py start`. Full duties: `start --full`, CLAUDE.md s3.")
        return 0
    _rule("NEXT ACTIONS")
    print("  1. Everything above came from disk. You do NOT need to ask the")
    print("     operator what to do - `now` says it and `blocked_on_operator`")
    print("     is the only thing that is genuinely theirs to answer.")
    print("  2. Collect anything triage listed, THEN assign, THEN start `now`.")
    print("  3. Read CURRENT_STATUS.md once. HANDOFF.md ONLY as the slice:")
    print("       sed -n '/^## Active claims/,/^## Direction notes/p' HANDOFF.md")
    print("     Never read HANDOFF_ARCHIVE.md end to end.")
    if hand.get("ending_a_session"):
        ## THE FULL TEXT IS PRINTED BELOW, NOT HERE. This line used to be
        ## `[:300]` with no ellipsis, which SILENTLY DROPPED everything past
        ## 300 characters - an end-of-session duty written into this key on
        ## 2026-09-22 vanished the moment it was saved, and the only symptom
        ## was a sentence that stopped mid-thought. Same family as the
        ## handover keys `start` never renders at all. The head stays short
        ## because this is a numbered list, and the cut is now VISIBLE.
        _one_line = " ".join(str(hand["ending_a_session"]).split())
        _head = _one_line[:300]
        if len(_one_line) > 300:
            _head += " ... (full text under ENDING A SESSION below)"
        print("  4. " + _head)

    ## OPERATOR RULE 2026-09-22: the end-of-session duties include showing
    ## any new animation. That instruction lives in `ending_a_session`, so
    ## the key has to render in FULL somewhere or the rule is invisible.
    if hand.get("ending_a_session"):
        _rule("ENDING A SESSION - the duties, in full")
        print(_wrap(str(hand["ending_a_session"]), indent="  "))
    return 0

def main() -> int:
    for stream in (sys.stdout, sys.stderr):
        try: stream.reconfigure(encoding="utf-8")
        except Exception: pass
    parser = argparse.ArgumentParser(description="FightCamp agent mailbox + status board")
    commands = parser.add_subparsers(dest="command", required=True)

    st = commands.add_parser("start", help="THE session-start command: what to do now, what is waiting on the operator, what is uncollected, who holds what - all derived from roadmap.json and the live board")
    st.add_argument("--full", action="store_true", help="the whole pre-S127 orientation (route status, clip report, triage lists, settings, traps, decided, ending duties)")
    st.set_defaults(handler=start)
    s = commands.add_parser("send"); s.add_argument("--from", dest="sender", required=True, type=agent); s.add_argument("--to", dest="recipient", required=True, type=addressee); s.add_argument("--topic", required=True); s.add_argument("--body", required=True); s.set_defaults(handler=send)
    i = commands.add_parser("inbox"); i.add_argument("--agent", required=True, type=addressee); i.set_defaults(handler=inbox)
    a = commands.add_parser("ack"); a.add_argument("--agent", required=True, type=addressee); a.add_argument("--id", dest="message_id", required=True); a.set_defaults(handler=ack)

    ask = commands.add_parser("ask", help="append a question for the operator to the ops board")
    ask.add_argument("text"); ask.add_argument("--options", default="", help="pipe-separated options; omit for free text")
    ask.add_argument("--attach", default="", help="pipe-separated repo paths (.md doc / image) the operator sees under the question; REQUIRED for an approval")
    ask.set_defaults(handler=_ask_cmd)

    br = commands.add_parser("brief", help="print (and copy) an agent's open task file(s) + unread inbox in one paste block")
    br.add_argument("--agent", required=True, type=agent); br.add_argument("--no-clip", action="store_true"); br.set_defaults(handler=brief)

    bo = commands.add_parser("board", help="one status table: task, agent, status, gate, title"); bo.set_defaults(handler=board)
    ho = commands.add_parser("handover", help="THE end-of-session gate: refuses if the roadmap is behind the code, the tree is dirty, commits are unpushed or a HANDOFF header cannot be parsed - then prints the one-line prompt")
    ho.set_defaults(handler=handover)

    commands.add_parser("evidence", help="tasks closed by a landed deliverable rather than by a hand-written HANDOFF header, with the file that closed each one").set_defaults(handler=evidence_report)
    tk = commands.add_parser("tasks", aliases=["task", "open", "todo"], help="THE answer to 'check for tasks': every OPEN task file, who owns it, where it lives")
    tk.add_argument("--agent", type=agent, default=None)
    tk.add_argument("--write", action="store_true", help="also regenerate TASKS.md at the repo root")
    tk.set_defaults(handler=tasks)

    bl = commands.add_parser("block", help="record a blocker against a task; survives /clear")
    bl.add_argument("--task", required=True); bl.add_argument("--agent", required=True, type=agent); bl.add_argument("--why", required=True); bl.set_defaults(handler=block)

    ub = commands.add_parser("unblock", help="clear the open blocker(s) on a task")
    ub.add_argument("--task", required=True); ub.set_defaults(handler=unblock)

    tr = commands.add_parser("triage", help="report-only: finished work that never reached the board - unmerged branches, branch-only mail, digests with no HANDOFF block, open tasks whose gate cannot run")
    tr.add_argument("--no-fetch", action="store_true", help="skip the git fetch (offline, or you just fetched)")
    tr.set_defaults(handler=triage)
    sc = commands.add_parser("scan", help="surface pushed research/digests HANDOFF hasn't mentioned yet, plus recent commits"); sc.set_defaults(handler=scan)

    sw = commands.add_parser("sweep", help="move finished '### ' blocks out of HANDOFF.md Active claims into HANDOFF_ARCHIVE.md (the morning chore CLAUDE.md asks for)")
    sw.add_argument("--dry-run", action="store_true", help="list what would move and write nothing"); sw.set_defaults(handler=sweep)

    do = commands.add_parser("done", help="run the parse gate on a task's own '## Owned files' .gd list and record pass/fail")
    do.add_argument("--task", required=True); do.set_defaults(handler=done)

    sh = commands.add_parser("ship", help="mark THIS session as having shipped its stage - the build tools refuse afterwards (one session, one stage)")
    sh.set_defaults(handler=ship)

    args = parser.parse_args()
    return args.handler(args)

if __name__ == "__main__": raise SystemExit(main())
