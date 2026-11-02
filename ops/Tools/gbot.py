"""gbot.py - drive the Grok bots (Kalli / John / Maria) with the cloud pod woken first.

S180 (operator 2026-10-08: "i do not want this to happen again fix it once and for all"): the Grok Bot app parks
its cloud pod whenever its window is unfocused, and bare `gbot` then fails with "417 Expectation Failed"
(x-anyrun-failure-reason: pod_hibernated). This wrapper wakes the pod (Tools/gbot_wake.mjs), runs gbot, and if gbot
still meets a parked pod it wakes again and retries once. Use it instead of bare gbot:

    python Tools/gbot.py wake                                    just wake; prints the GBOT WAKE line
    python Tools/gbot.py send --to John --file research/TASK_J66.md
    python Tools/gbot.py thread --to John --full [--limit 20] [--out path.txt]
    python Tools/gbot.py bots list                               any other gbot command passes through unchanged

--to takes a short name (kalli, john, maria) or the bot's full name; --file sends that file's text as the message
(no shell quoting); --out also writes the command's stdout to a file. The same commands run from a cloud session
through the PC runner: pc.yml job=agent args="gbot send --to John --file research/TASK_x.md".
"""
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
WAKE = os.path.join(HERE, "gbot_wake.mjs")
PARKED_MARKS = ("417", "Expectation Failed", "pod_hibernated")
NO_WAKE = {"--help", "-h", "--version", "doctor", "history"}
BOTS = {"kalli": "Kalli", "john": "John Research", "maria": "Maria Art Director", "dev": "Grok Dev"}  # S217: dev = coding seat (skill fightcamp-coding-seat)


def wake() -> bool:
    node = shutil.which("node")
    if node is None:
        print("GBOT WAKE FAIL node not on PATH")
        return False
    try:
        r = subprocess.run([node, WAKE], capture_output=True, text=True, encoding="utf-8", errors="replace",
                           timeout=240)
    except subprocess.TimeoutExpired:
        print("GBOT WAKE FAIL timed out")
        return False
    line = (r.stdout.strip().splitlines() or [r.stderr.strip()[:200]])[-1]
    ## stdout, not stderr: Windows PowerShell 5.1 under `2>&1` (the PC runner) turns any stderr line into a
    ## terminating NativeCommandError (S180: the runner woke the pod, then died on this line).
    print(line, flush=True)
    return r.returncode == 0


GBOT_VERSION = "0.12.4"  # pinned: the version S180 proved against the gateway
GBOT_HOME = "E:/FightCamp/tools/gbot" if os.path.isdir("E:/") else os.path.join(
    os.environ.get("LOCALAPPDATA", os.path.expanduser("~/AppData/Local")), "FightCamp", "gbot")


def _mjs_under(prefix_dir: str) -> str:
    return os.path.join(prefix_dir, "node_modules", "grok-bot-cli", "dist", "bin", "gbot.mjs")


def gbot_cmd() -> list:
    """node + gbot.mjs directly: the npm gbot.cmd shim goes through cmd.exe, which caps a command line at 8,191
    characters - a TASK brief sent as the message is often longer (CreateProcess allows 32K).
    S180: a `npm install -g` from Claude's shell lands in Claude's sandbox overlay, invisible to the PC runner and the
    operator (memory project_shell_sandbox_split), so when no gbot.mjs is visible we install the pinned version once
    into GBOT_HOME on the real disk and use it from there."""
    node = shutil.which("node")
    exe = shutil.which("gbot")
    npm_dirs = [os.path.dirname(exe)] if exe else []
    npm_dirs.append(os.path.join(os.environ.get("APPDATA", os.path.expanduser("~/AppData/Roaming")), "npm"))
    npm_dirs.append(GBOT_HOME)
    for npm_dir in npm_dirs:
        if node and os.path.exists(_mjs_under(npm_dir)):
            return [node, _mjs_under(npm_dir)]
    npm = shutil.which("npm")
    if node and npm:
        print("gbot not visible here - installing grok-bot-cli@%s into %s (once)" % (GBOT_VERSION, GBOT_HOME), flush=True)
        os.makedirs(GBOT_HOME, exist_ok=True)
        subprocess.run([npm, "install", "--prefix", GBOT_HOME, "grok-bot-cli@" + GBOT_VERSION, "--no-audit", "--no-fund"],
                       capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=600)
        if os.path.exists(_mjs_under(GBOT_HOME)):
            return [node, _mjs_under(GBOT_HOME)]
    if exe:
        return [exe]
    print("gbot not installed: npm install -g grok-bot-cli (node=%s, npm=%s, looked in %s)" % (node, npm, npm_dirs))
    sys.exit(127)


def run_gbot(args: list) -> subprocess.CompletedProcess:
    return subprocess.run(gbot_cmd() + args, capture_output=True, text=True, encoding="utf-8", errors="replace",
                          timeout=900)


def translate(args: list) -> tuple:
    """Our flags (--to, --file, --out) -> gbot's positional form. Returns (gbot_args, out_path)."""
    if not args or args[0] not in ("send", "thread"):
        return args, ""
    sub, rest = args[0], args[1:]
    to, msg_file, out, passthru = "", "", "", []
    i = 0
    while i < len(rest):
        a = rest[i]
        if a in ("--to", "--file", "--out") and i + 1 < len(rest):
            v = rest[i + 1]
            if a == "--to":
                to = BOTS.get(v.lower(), v)
            elif a == "--file":
                msg_file = v
            else:
                out = v
            i += 2
            continue
        passthru.append(a)
        i += 1
    if not to:  # old positional form: gbot.py thread "John Research" --full
        return args, out
    if sub == "thread":
        return ["thread", to] + passthru, out
    if msg_file:
        path = msg_file if os.path.isabs(msg_file) else os.path.join(ROOT, msg_file)
        with open(path, encoding="utf-8") as fh:
            text = fh.read()
        return ["send", to, text] + passthru, out
    return ["send", to] + passthru, out


DIRECT = os.path.join(HERE, "grokbot_direct.mjs")


def direct(args: list) -> int:
    """S230: grok-bot-cli 0.12.4 cannot reach the app's box any more (descriptor v3 + its EnsureSandBox sends an old
    client version); grokbot_direct.mjs talks to the same gateway with the installed app's version. send/thread/list
    go there; --to/--file/--out/--limit keep their meaning."""
    node = shutil.which("node")
    sub, rest = args[0], args[1:]
    opts, i = {}, 0
    while i < len(rest):
        if rest[i] in ("--to", "--file", "--out", "--limit") and i + 1 < len(rest):
            opts[rest[i]] = rest[i + 1]
            i += 2
        else:
            opts.setdefault("_pos", []).append(rest[i])
            i += 1
    bot = opts.get("--to") or (opts.get("_pos") or [""])[0]
    if sub == "list":
        cmd = [node, DIRECT, "list"]
    elif sub == "send":
        path = opts.get("--file", "")
        path = path if os.path.isabs(path) else os.path.join(ROOT, path)
        cmd = [node, DIRECT, "send", bot, path]
    else:
        cmd = [node, DIRECT, "tail", bot, opts.get("--limit", "20")] + (["--out", opts["--out"]] if "--out" in opts else [])
    return subprocess.run(cmd).returncode


def main() -> int:
    if sys.argv[1:2] and sys.argv[1] in ("send", "thread", "list"):
        return direct(sys.argv[1:])
    # A piped stdout on Windows is cp1252; bot replies hold characters it cannot encode (S180 crash on John's J65).
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(encoding="utf-8", errors="replace")
        except (AttributeError, ValueError):
            pass
    args = sys.argv[1:]
    if args[:1] == ["wake"]:
        return 0 if wake() else 1
    gargs, out = translate(args)
    if not (set(args[:1]) & NO_WAKE):
        wake()
    r = run_gbot(gargs)
    text = (r.stdout or "") + (r.stderr or "")
    if r.returncode != 0 and any(m in text for m in PARKED_MARKS):
        print("gbot met a parked pod - waking and retrying once", flush=True)
        wake()
        r = run_gbot(gargs)
    if out:  # the file first: it must exist even if the console cannot show the text
        os.makedirs(os.path.dirname(os.path.abspath(out)) or ".", exist_ok=True)
        with open(out, "w", encoding="utf-8") as fh:
            fh.write(r.stdout or "")
    sys.stdout.write(r.stdout or "")
    sys.stderr.write(r.stderr or "")
    return r.returncode


if __name__ == "__main__":
    sys.exit(main())
