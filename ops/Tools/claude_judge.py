"""claude_judge.py - Claude's eyes as the loop judge while Gemini is out (S380).

Operator S380, on the Gemini API prepay running dry (HTTP 402): "Judge by Claude's eyes". The dispatcher's judge
(seat_dispatch.judge) falls back to this when gemini_judge.py writes no verdict:

    python Tools/claude_judge.py <film.mp4> [--kind fight|bjj] [--what LABEL] [--intent TEXT] [--every 10]

1. `eyes index` the film, then one 16-frame `eyes burst` (3 s) every --every seconds - contact sheets, as Claude reads a
   clip in a session (feedback: eyes on every animation);
2. copies them to E:/FightCamp/tmp/claude_judge/<film stem>/ (outside the repo: no repo hooks or CLAUDE.md load);
3. runs the standalone Claude CLI headless (`claude -p`, Read tool only, that folder only) on gemini_judge's own
   FIGHT_PROMPT / BJJ_PROMPT, so the criteria and the "Score: N/10" verdict line stay the same as Argon's;
4. writes the answer to <film>.gemini_argon.md (the file seat_dispatch reads), its first line naming the judge.
Exit 0 with a verdict, 1 without. Runs on the operator's Claude plan - no Gemini spend.
"""
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gemini_judge  # noqa: E402  (the same prompts as Argon)

CLAUDE = Path.home() / ".local" / "bin" / "claude.exe"
WORK = Path("E:/FightCamp/tmp/claude_judge")
MODEL = "claude-opus-5-5"
NO_WINDOW = 0x08000000 if sys.platform == "win32" else 0
SHEET_NOTE = """
YOU SEE CONTACT SHEETS, NOT THE VIDEO. Every image in this folder is one 16-frame burst over 3 seconds of the film,
left to right, top to bottom; its file name gives the film time it starts at (03_at_0m40.0s.jpg = 0:40 to 0:43).
Files ending _tight are 16 CONSECUTIVE frames (~0.5 s): judge trembling, popping and jitter on those.
Open EVERY image with your Read tool before you answer, in order. Judge exactly as the instructions above say, with
film times taken from the file names. Answer in the format above; the Verdict section must have a line
"Score: N/10" (N a whole or half number). Write nothing to disk.
"""


def run(cmd: list, timeout: int, cwd: Path | None = None) -> subprocess.CompletedProcess:
    return subprocess.run([str(c) for c in cmd], capture_output=True, text=True, encoding="utf-8", errors="replace",
                          timeout=timeout, cwd=str(cwd) if cwd else None, creationflags=NO_WINDOW)


def seconds(mp4: Path) -> float:
    p = run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "default=nw=1:nk=1", mp4], 60)
    try:
        return float(p.stdout.strip())
    except ValueError:
        return 0.0


def sheets(mp4: Path, out: Path, every: float) -> list[Path]:
    idx = json.loads(run(["eyes", "index", mp4, "--json"], 900).stdout or "{}")
    ref = str(idx.get("id") or idx.get("ref") or "")
    dur = seconds(mp4)
    if not ref or dur <= 0.0:
        return []
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)
    got: list[Path] = []
    # (centre, span, name): a 3 s sheet every `every` s, and three TIGHT sheets (16 frames in ~0.53 s = every frame at
    # 30 fps) at a quarter, half and three quarters - trembling only shows frame to frame (S380: 0.2 s apart hid it)
    plan = [(c, 3.0, "") for c in [1.5 + every * i for i in range(int((dur - 2.0) // every) + 1)] if c < dur - 1.5]
    plan += [(dur * q, 0.53, "_tight") for q in (0.25, 0.5, 0.75)]
    for c, span, tag in sorted(plan):
        b = json.loads(run(["eyes", "burst", ref, f"{c:.2f}", "--count", "16", "--span", str(span), "--width", "1600",
                            "--json"], 300).stdout or "{}")
        src = Path(str(b.get("sheet") or b.get("path") or ""))
        if src.is_file():
            t0 = max(0.0, c - span / 2.0)   # eyes centres the burst on c: the file name says where it STARTS
            dst = out / f"{len(got):02d}_at_{int(t0) // 60}m{t0 % 60:04.1f}s{tag}.jpg"
            shutil.copyfile(src, dst)
            got.append(dst)
    return got


def out_dir(mp4: Path) -> Path:
    """S385: <task>_<stem> - every loop film is after.mp4 / before.mp4, so the stem alone let BJJ9R16 overwrite FIGHT9R13."""
    return WORK / f"{mp4.parent.name}_{mp4.stem}".replace(".", "_")


def judge(mp4: Path, kind: str, what: str, intent: str, every: float = 10.0) -> Path | None:
    out = out_dir(mp4)
    shots = sheets(mp4, out, every)
    if not shots:
        print(f"CLAUDE_JUDGE no contact sheets for {mp4}")
        return None
    prompt = (gemini_judge.BJJ_PROMPT if kind == "bjj" else gemini_judge.FIGHT_PROMPT) + (f"\nContext: {intent}" if intent else "")
    prompt += SHEET_NOTE
    exe = CLAUDE if CLAUDE.is_file() else Path(shutil.which("claude") or "claude")
    p = run([exe, "-p", prompt, "--model", MODEL, "--allowedTools", "Read", "--add-dir", out, "--output-format", "text"],
            1800, cwd=out)
    text = (p.stdout or "").strip()
    if p.returncode != 0 or "score" not in text.lower():
        print(f"CLAUDE_JUDGE failed (rc {p.returncode}): {(p.stderr or text)[-400:]}")
        return None
    md = mp4.with_suffix(".gemini_argon.md")
    md.write_text(f"# JUDGE: Claude {MODEL} on {len(shots)} eyes contact sheets ({what or mp4.name}) - Gemini prepay out, "
                  f"S380 operator: \"Judge by Claude's eyes\"\n\n{text}\n", encoding="utf-8")
    print(f"CLAUDE_JUDGE {md}")
    return md


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("film")
    ap.add_argument("--kind", choices=["fight", "bjj"], default="fight")
    ap.add_argument("--what", default="")
    ap.add_argument("--intent", default="")
    ap.add_argument("--every", type=float, default=10.0)
    a = ap.parse_args(argv)
    return 0 if judge(Path(a.film), a.kind, a.what, a.intent, a.every) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
